{
  mkDerivation,
  extra-cmake-modules,
  frameworkintegration, kcmutils, kcompletion, kconfig, kdecoration, kguiaddons,
  ki18n, kwidgetsaddons, kservice, kwayland, kwindowsystem, qtx11extras
}:

mkDerivation {
  name = "oxygen";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    frameworkintegration kcmutils kcompletion kconfig kdecoration kguiaddons
    ki18n kservice kwayland kwidgetsaddons kwindowsystem qtx11extras
  ];
}
