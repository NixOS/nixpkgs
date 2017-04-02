{
  plasmaPackage,
  extra-cmake-modules,
  frameworkintegration, kcmutils, kconfigwidgets, kcoreaddons, kdecoration,
  kguiaddons, ki18n, kwayland, kwindowsystem, plasma-framework, qtx11extras
}:

plasmaPackage {
  name = "breeze-qt5";
  sname = "breeze";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    frameworkintegration kcmutils kconfigwidgets kcoreaddons kdecoration
    kguiaddons ki18n kwayland kwindowsystem plasma-framework qtx11extras
  ];
  cmakeFlags = [ "-DUSE_Qt4=OFF" ];
}
