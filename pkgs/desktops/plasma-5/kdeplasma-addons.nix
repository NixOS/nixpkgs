{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kcoreaddons, kcmutils, kdelibs4support, ki18n, kio,
  knewstuff, kross, krunner, kservice, ksysguard, kunitconversion, ibus,
  plasma-framework, plasma-workspace, qtdeclarative, qtx11extras,
}:

mkDerivation {
  name = "kdeplasma-addons";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kcmutils kdelibs4support kio knewstuff
    kross krunner kservice ksysguard kunitconversion ibus plasma-framework
    plasma-workspace qtdeclarative qtx11extras
  ];
}
