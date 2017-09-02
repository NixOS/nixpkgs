{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  gconf, glib, kconfigwidgets, kcoreaddons, kdeclarative, kglobalaccel, ki18n,
  libcanberra_gtk3, libpulseaudio, plasma-framework, qtdeclarative, kwindowsystem
}:

mkDerivation {
  name = "plasma-pa";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    gconf glib kconfigwidgets kcoreaddons kdeclarative kglobalaccel ki18n
    libcanberra_gtk3 libpulseaudio plasma-framework qtdeclarative kwindowsystem
  ];
}
