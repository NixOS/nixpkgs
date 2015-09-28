{ mkDerivation, lib
, extra-cmake-modules
, boost
, kcmutils
, kconfig
, kcoreaddons
, kdbusaddons
, kdeclarative
, kglobalaccel
, ki18n
, kio
, kservice
, kwindowsystem
, kxmlgui
, qtdeclarative
}:

mkDerivation {
  name = "kactivities";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    boost
    kcmutils
    kconfig
    kcoreaddons
    kdbusaddons
    kdeclarative
    kglobalaccel
    ki18n
    kio
    kservice
    kwindowsystem
    kxmlgui
    qtdeclarative
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kactivitymanagerd"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
