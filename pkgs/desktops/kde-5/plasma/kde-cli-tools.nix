{
  plasmaPackage, ecm,
  kcmutils, kconfig, kdelibs4support, kdesu, kdoctools, ki18n, kiconthemes,
  kwindowsystem, qtsvg, qtx11extras
}:

plasmaPackage {
  name = "kde-cli-tools";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kcmutils kconfig kdesu kdelibs4support ki18n kiconthemes kwindowsystem qtsvg
    qtx11extras
  ];
}
