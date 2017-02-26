{
  plasmaPackage, kdeWrapper,
  extra-cmake-modules,
  frameworkintegration, kcmutils, kcompletion, kconfig, kdecoration, kguiaddons,
  ki18n, kwidgetsaddons, kservice, kwayland, kwindowsystem, qtx11extras
}:

let
  unwrapped = plasmaPackage {
    name = "oxygen";
    nativeBuildInputs = [ extra-cmake-modules ];
    propagatedBuildInputs = [
      frameworkintegration kcmutils kcompletion kconfig kdecoration kguiaddons
      ki18n kservice kwayland kwidgetsaddons kwindowsystem qtx11extras
    ];
  };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/oxygen-demo5" "bin/oxygen-settings5" ];
}
