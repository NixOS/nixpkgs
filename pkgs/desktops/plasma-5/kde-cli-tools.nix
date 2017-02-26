{
  plasmaPackage, extra-cmake-modules,
  kcmutils, kconfig, kdelibs4support, kdesu, kdoctools, ki18n, kiconthemes,
  kwindowsystem, qtsvg, qtx11extras
}:

plasmaPackage {
  name = "kde-cli-tools";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kcmutils kconfig kdesu kdelibs4support ki18n kiconthemes kwindowsystem qtsvg
    qtx11extras
  ];
}
