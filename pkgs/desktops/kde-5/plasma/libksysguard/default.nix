{ fetchpatch, plasmaPackage, ecm, kauth, kcompletion
, kconfigwidgets, kcoreaddons, kservice, kwidgetsaddons
, kwindowsystem, plasma-framework, qtscript, qtx11extras
, kconfig, ki18n, kiconthemes
}:

plasmaPackage {
  name = "libksysguard";
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
  ];
  nativeBuildInputs = [
    ecm
  ];
  propagatedBuildInputs = [
    kauth kconfig ki18n kiconthemes kwindowsystem plasma-framework qtx11extras
    kcompletion kconfigwidgets kcoreaddons kservice kwidgetsaddons qtscript
  ];
}
