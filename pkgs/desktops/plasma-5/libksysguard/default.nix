{
  plasmaPackage,
  extra-cmake-modules,
  kauth, kcompletion, kconfig, kconfigwidgets, kcoreaddons, ki18n, kiconthemes,
  kservice, kwidgetsaddons, kwindowsystem, plasma-framework, qtscript, qtwebkit,
  qtx11extras
}:

plasmaPackage {
  name = "libksysguard";
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kauth kconfig ki18n kiconthemes kwindowsystem kcompletion kconfigwidgets
    kcoreaddons kservice kwidgetsaddons plasma-framework qtscript qtx11extras
    qtwebkit
  ];
}
