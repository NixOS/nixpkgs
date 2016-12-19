{ plasmaPackage
, ecm
, boost, kconfig, kcoreaddons, kdbusaddons, ki18n, kio, kglobalaccel
, kwindowsystem, kxmlgui
}:

plasmaPackage {
  name = "kactivitymanagerd";
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    boost kconfig kcoreaddons kdbusaddons kglobalaccel ki18n kio kwindowsystem
    kxmlgui
  ];
}
