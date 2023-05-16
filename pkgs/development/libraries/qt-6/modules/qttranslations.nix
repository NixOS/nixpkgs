{ qtModule
, qttools
}:

qtModule {
  pname = "qttranslations";
<<<<<<< HEAD
  nativeBuildInputs = [ qttools ];
  outputs = [ "out" ];
=======
  qtInputs = [ qttools ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
