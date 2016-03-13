{ kdeFramework, lib, extra-cmake-modules, boost, kcmutils, kconfig
, kcoreaddons, kdbusaddons, kdeclarative, kglobalaccel, ki18n
, kio, kservice, kwindowsystem, kxmlgui, makeQtWrapper, qtdeclarative
}:

kdeFramework {
  name = "kactivities";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  buildInputs = [
    boost kcmutils kconfig kcoreaddons kdbusaddons kservice
    kxmlgui
  ];
  propagatedBuildInputs = [
    kdeclarative kglobalaccel ki18n kio kwindowsystem qtdeclarative
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kactivitymanagerd"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
