{ fetchpatch, plasmaPackage, extra-cmake-modules, kauth, kcompletion
, kconfigwidgets, kcoreaddons, kservice, kwidgetsaddons
, kwindowsystem, plasma-framework, qtscript, qtwebkit, qtx11extras
, kconfig, ki18n, kiconthemes
}:

plasmaPackage {
  name = "libksysguard";
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
  ];
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcompletion kconfigwidgets kcoreaddons kservice
    kwidgetsaddons qtscript qtwebkit
  ];
  propagatedBuildInputs = [
    kauth kconfig ki18n kiconthemes kwindowsystem plasma-framework
    qtx11extras
  ];
}
