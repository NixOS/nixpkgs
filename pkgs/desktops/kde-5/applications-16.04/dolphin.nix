{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kinit
, kcmutils
, kcoreaddons
, knewstuff
, ki18n
, kdbusaddons
, kbookmarks
, kconfig
, kio
, kparts
, solid
, kiconthemes
, kcompletion
, ktexteditor
, kwindowsystem
, knotifications
, kactivities
, phonon
, baloo
, baloo-widgets
, kfilemetadata
, kdelibs4support
}:

kdeApp {
  name = "dolphin";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  propagatedBuildInputs = [
    kinit kcmutils kcoreaddons knewstuff kdbusaddons kbookmarks kconfig kparts
    solid kiconthemes kcompletion knotifications phonon baloo-widgets baloo
    kactivities kdelibs4support kfilemetadata ki18n kio ktexteditor
    kwindowsystem
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/dolphin"
  '';
}
