{ plasmaPackage, extra-cmake-modules, kdoctools, ibus, kconfig
, kconfigwidgets, kcoreaddons, kcmutils, kdelibs4support, ki18n
, kio, knewstuff, kross, krunner, kservice, kunitconversion
, plasma-framework, plasma-workspace, qtdeclarative, qtx11extras
}:

plasmaPackage {
  name = "kdeplasma-addons";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    kdelibs4support kio kross krunner plasma-framework plasma-workspace
    qtdeclarative qtx11extras ibus kconfig kconfigwidgets kcoreaddons kcmutils
    knewstuff kservice kunitconversion
  ];
}
