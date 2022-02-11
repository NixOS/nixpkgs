{
  mkDerivation,
  extra-cmake-modules,
  frameworkintegration, kcmutils, kcompletion, kconfig, kdecoration, kguiaddons,
  ki18n, kwidgetsaddons, kservice, kwayland, kwindowsystem, qtdeclarative,
  qtx11extras, libXdmcp
}:

mkDerivation {
  name = "oxygen";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    frameworkintegration kcmutils kcompletion kconfig kdecoration kguiaddons
    ki18n kservice kwayland kwidgetsaddons kwindowsystem qtdeclarative
    qtx11extras libXdmcp
  ];
  outputs = [ "bin" "dev" "out" ];
}
