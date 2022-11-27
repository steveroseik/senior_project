import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test1/APILibraries.dart';
import 'package:flutter_app_test1/FETCH_wdgts.dart';
import 'package:flutter_app_test1/configuration.dart';
import 'package:flutter_app_test1/routesGenerator.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../JsonObj.dart';

class PetMatchPage extends StatefulWidget {
  final PetPod senderPet;
  final List<PetProfile> pets;
  const PetMatchPage({Key? key, required this.pets, required this.senderPet}) : super(key: key);

  @override
  State<PetMatchPage> createState() => _PetMatchPageState();
}

class _PetMatchPageState extends State<PetMatchPage> {

   List<PetView> petMatches = <PetView>[];
   late List<Widget> petDialogs;
   bool petsReady = false;
   int swipeBool = 1;
   final AppinioSwiperController controller = AppinioSwiperController();



   initPets() async{
     final prefs = await SharedPreferences.getInstance();
     final uLat = prefs.getDouble('lat');
     final uLong = prefs.getDouble('long');
    for (PetProfile pet in widget.pets){
      final pod = PetPod(pet, false, GeoLocation(0,0), 0);
      final petView = PetView(profile: pod, ownerPets: [widget.senderPet]);
      petMatches.add(petView);
    }
    print('done');
    setState(() {
      petsReady = true;
    });
  }

  @override
  void initState() {
    initPets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
          appBar: init_appBar(BA_key),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mating Choices For ${widget.senderPet.pet.name}',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              petsReady ? Container(
                height: 600,
                child: AppinioSwiper(
                  unlimitedUnswipe: true,
                  controller: controller,
                  unswipe: _unswipe,
                  cards: petMatches,
                  onSwipe: _swipe,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 50,
                    bottom: 40,
                  ),
                ),
              ) : Container()
            ],
          ),
        )
    );

  }
   void _swipe(int index, AppinioSwiperDirection direction) {
     print("the card was swiped to the: " + direction.name);
   }

   void _unswipe(bool unswiped) {
     if (unswiped) {
       print("SUCCESS: card was unswiped");
     } else {
       print("FAIL: no card left to unswipe");
     }
   }
}
