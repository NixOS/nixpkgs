{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kconfigwidgets, kcoreaddons, kdeclarative, kglobalaccel, ki18n, kwindowsystem, plasma-framework,
  qtbase, qtdeclarative,
  gconf, glib, libcanberra-gtk3, libpulseaudio, sound-theme-freedesktop
}:

mkDerivation {
  name = "plasma-pa";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gconf glib libcanberra-gtk3 libpulseaudio sound-theme-freedesktop

    kconfigwidgets kcoreaddons kdeclarative kglobalaccel ki18n plasma-framework
    kwindowsystem

    qtbase qtdeclarative
  ];
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
}
