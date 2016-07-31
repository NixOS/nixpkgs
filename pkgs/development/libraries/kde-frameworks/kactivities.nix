{ kdeFramework, lib, ecm, boost, kcmutils, kconfig
, kcoreaddons, kdbusaddons, kdeclarative, kglobalaccel, ki18n
, kio, kservice, kwindowsystem, kxmlgui, qtdeclarative
}:

kdeFramework {
  name = "kactivities";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    boost kcmutils kconfig kcoreaddons kdbusaddons kdeclarative kglobalaccel
    ki18n kio kservice kwindowsystem kxmlgui qtdeclarative
  ];
}
