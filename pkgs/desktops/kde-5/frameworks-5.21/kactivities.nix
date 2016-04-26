{ kdeFramework, lib, extra-cmake-modules, boost, kcmutils, kconfig
, kcoreaddons, kdbusaddons, kdeclarative, kglobalaccel, ki18n
, kio, kservice, kwindowsystem, kxmlgui, qtdeclarative
}:

kdeFramework {
  name = "kactivities";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    boost kcmutils kconfig kcoreaddons kdbusaddons kservice
    kxmlgui
  ];
  propagatedBuildInputs = [
    kdeclarative kglobalaccel ki18n kio kwindowsystem qtdeclarative
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
