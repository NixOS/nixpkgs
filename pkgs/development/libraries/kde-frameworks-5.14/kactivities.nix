{ kdeFramework, lib, extra-cmake-modules, boost, kcmutils, kconfig
, kcoreaddons, kdbusaddons, kdeclarative, kglobalaccel, ki18n
, kio, kservice, kwindowsystem, kxmlgui, qtdeclarative
}:

kdeFramework {
  name = "kactivities";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    boost kcmutils kconfig kcoreaddons kdbusaddons ki18n kio kservice
    kwindowsystem kxmlgui
  ];
  propagatedBuildInputs = [ kdeclarative kglobalaccel qtdeclarative ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kactivitymanagerd"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
