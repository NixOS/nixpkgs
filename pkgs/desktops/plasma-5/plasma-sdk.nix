{ mkDerivation
, extra-cmake-modules
, karchive
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdeclarative
, ki18n
, kiconthemes
, kio
, kitemmodels
, plasma-framework
, kservice
, ktexteditor
, kwidgetsaddons
, kdoctools
<<<<<<< HEAD
=======
, qtbase
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation {
  pname = "plasma-sdk";
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdeclarative
    ki18n
    kiconthemes
    kio
    kitemmodels
    plasma-framework
    kservice
    ktexteditor
    kwidgetsaddons
  ];
}
