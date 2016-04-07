{ plasmaPackage, extra-cmake-modules, kdoctools, ibus, kconfig
, kconfigwidgets, kcoreaddons, kcmutils, kdelibs4support, ki18n
, kio, knewstuff, kross, krunner, kservice, kunitconversion
, plasma-framework, qtdeclarative, qtx11extras, plasma-workspace
}:

plasmaPackage {
  name = "kdeplasma-addons";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    ibus kconfig kconfigwidgets kcoreaddons kcmutils
    knewstuff kservice kunitconversion plasma-workspace
  ];
  propagatedBuildInputs = [
    kdelibs4support kio kross krunner plasma-framework qtdeclarative
    qtx11extras
  ];
}
