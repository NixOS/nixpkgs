{
  mkDerivation, lib,
  extra-cmake-modules,
  kauth, kcompletion, kconfig, kconfigwidgets, kcoreaddons, ki18n, kiconthemes,
  knewstuff, kservice, kwidgetsaddons, kwindowsystem, plasma-framework,
  qtbase, qtscript, qtwebengine, qtx11extras
}:

mkDerivation {
  name = "libksysguard";
  meta.broken = lib.versionOlder qtbase.version "5.14.0";
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kauth kconfig ki18n kiconthemes kwindowsystem kcompletion kconfigwidgets
    kcoreaddons kservice kwidgetsaddons plasma-framework qtscript qtx11extras
    qtwebengine knewstuff
  ];
  outputs = [ "bin" "dev" "out" ];
}
