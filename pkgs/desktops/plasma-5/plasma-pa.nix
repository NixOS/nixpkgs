{
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kcmutils,
  kconfigwidgets,
  kcoreaddons,
  kdeclarative,
  kglobalaccel,
  ki18n,
  kwindowsystem,
  plasma-framework,
  qtbase,
  qtdeclarative,
  glib,
  libcanberra-gtk3,
  libpulseaudio,
  sound-theme-freedesktop,
}:

mkDerivation {
  pname = "plasma-pa";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    glib
    libcanberra-gtk3
    libpulseaudio
    sound-theme-freedesktop

    kcmutils
    kconfigwidgets
    kcoreaddons
    kdeclarative
    kglobalaccel
    ki18n
    plasma-framework
    kwindowsystem

    qtbase
    qtdeclarative
  ];
}
