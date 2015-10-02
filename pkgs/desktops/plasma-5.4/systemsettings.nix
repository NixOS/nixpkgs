{ plasmaPackage
, extra-cmake-modules
, kdoctools
, kitemviews
, kcmutils
, ki18n
, kio
, kservice
, kiconthemes
, kwindowsystem
, kxmlgui
, kdbusaddons
, kconfig
, khtml
}:

plasmaPackage {
  name = "systemsettings";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kitemviews
    kcmutils
    ki18n
    kio
    kservice
    kiconthemes
    kwindowsystem
    kxmlgui
    kdbusaddons
    kconfig
    khtml
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/systemsettings5"
  '';
}
