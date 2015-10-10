{ plasmaPackage, extra-cmake-modules, ki18n, kcmutils, kconfig
, kdecoration, kguiaddons, kwidgetsaddons, kservice, kcompletion
, frameworkintegration, kwindowsystem, qtx11extras
}:

plasmaPackage {
  name = "oxygen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcmutils kconfig kdecoration kguiaddons kwidgetsaddons
    kservice kcompletion
  ];
  propagatedBuildInputs = [ frameworkintegration ki18n kwindowsystem qtx11extras ];
  postInstall = ''
    wrapKDEProgram "$out/bin/oxygen-demo5"
    wrapKDEProgram "$out/bin/oxygen-settings5"
  '';
}
