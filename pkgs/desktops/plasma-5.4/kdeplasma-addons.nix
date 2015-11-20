{ plasmaPackage, extra-cmake-modules, kdoctools, ibus, kconfig
, kconfigwidgets, kcoreaddons, kcmutils, kdelibs4support, ki18n
, kio, knewstuff, kross, krunner, kservice, kunitconversion
, plasma-framework, qtdeclarative, qtx11extras
}:

plasmaPackage {
  name = "kdeplasma-addons";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    ibus kconfig kconfigwidgets kcoreaddons kcmutils
    knewstuff kservice kunitconversion
  ];
  propagatedBuildInputs = [
    kdelibs4support kio kross krunner plasma-framework qtdeclarative
    qtx11extras
  ];
}
