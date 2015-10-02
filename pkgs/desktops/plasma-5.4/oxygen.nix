{ plasmaPackage
, extra-cmake-modules
, ki18n
, kcmutils
, kconfig
, kdecoration
, kguiaddons
, kwidgetsaddons
, kservice
, kcompletion
, frameworkintegration
, kwindowsystem
, qtx11extras
}:

plasmaPackage {
  name = "oxygen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    ki18n
    kcmutils
    kconfig
    kdecoration
    kguiaddons
    kwidgetsaddons
    kservice
    kcompletion
    frameworkintegration
    kwindowsystem
    qtx11extras
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/oxygen-demo5"
    wrapKDEProgram "$out/bin/oxygen-settings5"
  '';
}
