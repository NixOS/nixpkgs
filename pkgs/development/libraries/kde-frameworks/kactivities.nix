{ mkDerivation, lib, extra-cmake-modules, boost, kcmutils, kconfig
, kcoreaddons, kdbusaddons, kdeclarative, kglobalaccel, ki18n
, kio, kservice, kwindowsystem, kxmlgui, qtdeclarative
}:

mkDerivation {
  name = "kactivities";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    boost kcmutils kconfig kcoreaddons kdbusaddons kdeclarative kglobalaccel
    ki18n kio kservice kwindowsystem kxmlgui qtdeclarative
  ];
}
