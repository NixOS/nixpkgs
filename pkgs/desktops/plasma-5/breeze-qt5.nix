{
  mkDerivation,
  extra-cmake-modules,
  frameworkintegration, kcmutils, kconfigwidgets, kcoreaddons, kdecoration,
  kguiaddons, ki18n, kwayland, kwindowsystem, plasma-framework, qtdeclarative,
  qtx11extras
}:

mkDerivation {
  name = "breeze-qt5";
  sname = "breeze";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    frameworkintegration kcmutils kconfigwidgets kcoreaddons kdecoration
    kguiaddons ki18n kwayland kwindowsystem plasma-framework qtdeclarative
    qtx11extras
  ];
  outputs = [ "bin" "dev" "out" ];
  cmakeFlags = [ "-DUSE_Qt4=OFF" ];
}
