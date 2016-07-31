{ plasmaPackage, ecm, kdoctools
, kconfig, kconfigwidgets, kcoreaddons, kcmutils, kdelibs4support, ki18n
, kio, knewstuff, kross, krunner, kservice, ksysguard, kunitconversion
, plasma-framework, plasma-workspace, qtdeclarative, qtx11extras
, ibus
}:

plasmaPackage {
  name = "kdeplasma-addons";
  nativeBuildInputs = [
    ecm
    kdoctools
  ];
  propagatedBuildInputs = [
    kconfig kconfigwidgets kcoreaddons kcmutils kdelibs4support kio knewstuff
    kross krunner kservice ksysguard kunitconversion plasma-framework
    plasma-workspace qtdeclarative qtx11extras
    ibus
  ];
}
