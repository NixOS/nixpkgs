{ mkDerivation
, extra-cmake-modules
, flatpak
, kcmutils
, kconfig
, kdeclarative
<<<<<<< HEAD
, kitemmodels
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation {
  pname = "flatpak-kcm";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    flatpak
    kcmutils
    kconfig
    kdeclarative
<<<<<<< HEAD
    kitemmodels
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];
}
