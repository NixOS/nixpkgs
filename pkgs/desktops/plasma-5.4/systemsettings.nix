{ plasmaPackage, extra-cmake-modules, kdoctools, kitemviews
, kcmutils, ki18n, kio, kservice, kiconthemes, kwindowsystem
, kxmlgui, kdbusaddons, kconfig, khtml
}:

plasmaPackage {
  name = "systemsettings";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
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
