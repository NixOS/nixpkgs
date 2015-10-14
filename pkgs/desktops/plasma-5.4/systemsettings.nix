{ plasmaPackage, extra-cmake-modules, kdoctools, kitemviews
, kcmutils, ki18n, kio, kservice, kiconthemes, kwindowsystem
, kxmlgui, kdbusaddons, kconfig, khtml, makeKDEWrapper
}:

plasmaPackage {
  name = "systemsettings";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeKDEWrapper
  ];
  buildInputs = [
    kitemviews kcmutils kservice kiconthemes kxmlgui kdbusaddons
    kconfig
  ];
  propagatedBuildInputs = [ khtml ki18n kio kwindowsystem ];
  postInstall = ''
    wrapKDEProgram "$out/bin/systemsettings5"
  '';
}
