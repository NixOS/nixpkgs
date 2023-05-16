{ mkDerivation
, extra-cmake-modules
, qtbase
, kfilemetadata
, kio
, ki18n
, kconfig
, kdbusaddons
, knotifications
, kpurpose
, krunner
, kwindowsystem
, kactivities
, plasma-workspace
}:

mkDerivation {
  pname = "plasma-browser-integration";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    qtbase
    kfilemetadata
    kio
    ki18n
    kconfig
    kdbusaddons
    knotifications
    kpurpose
    krunner
    kwindowsystem
    kactivities
    plasma-workspace
  ];
<<<<<<< HEAD

  meta = {
    description = "Components necessary to integrate browsers into the Plasma Desktop";
    homepage = "https://community.kde.org/Plasma/Browser_Integration";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
