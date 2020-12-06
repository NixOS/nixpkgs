{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kcoreaddons, kcmutils, kdelibs4support, kholidays,
  kio, knewstuff, kpurpose, kross, krunner, kservice, ksysguard,
  kunitconversion, ibus, plasma-framework, plasma-workspace, qtdeclarative,
  qtwebengine, qtx11extras
}:

mkDerivation {
  name = "kdeplasma-addons";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kcmutils kdelibs4support kholidays kio
    knewstuff kpurpose kross krunner kservice ksysguard kunitconversion ibus
    plasma-framework plasma-workspace qtdeclarative qtwebengine qtx11extras
  ];
}
