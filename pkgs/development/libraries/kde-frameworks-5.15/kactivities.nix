{ kdeFramework, lib, extra-cmake-modules, boost, kcmutils, kconfig
, kcoreaddons, kdbusaddons, kdeclarative, kglobalaccel, ki18n
, kio, kservice, kwindowsystem, kxmlgui, makeKDEWrapper, qtdeclarative
}:

kdeFramework {
  name = "kactivities";
  nativeBuildInputs = [ extra-cmake-modules makeKDEWrapper ];
  buildInputs = [
    boost kcmutils kconfig kcoreaddons kdbusaddons kservice
    kxmlgui
  ];
  propagatedBuildInputs = [
    kdeclarative kglobalaccel ki18n kio kwindowsystem qtdeclarative
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kactivitymanagerd"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
