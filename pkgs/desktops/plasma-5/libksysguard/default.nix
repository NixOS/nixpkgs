{
  mkDerivation,
  extra-cmake-modules,
  kauth, kcompletion, kconfig, kconfigwidgets, kcoreaddons, ki18n, kiconthemes,
  kservice, kwidgetsaddons, kwindowsystem, plasma-framework, qtscript, qtwebengine,
  qtx11extras
}:

mkDerivation {
  name = "libksysguard";
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kauth kconfig ki18n kiconthemes kwindowsystem kcompletion kconfigwidgets
    kcoreaddons kservice kwidgetsaddons plasma-framework qtscript qtx11extras
    qtwebengine
  ];
  outputs = [ "bin" "dev" "out" ];
}
