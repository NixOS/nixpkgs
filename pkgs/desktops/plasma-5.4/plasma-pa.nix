{ mkDerivation
, extra-cmake-modules
, glib
, kconfigwidgets
, kcoreaddons
, kdeclarative
, kglobalaccel
, ki18n
, libpulseaudio
, plasma-framework
}:

mkDerivation {
  name = "plasma-pa";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    glib
    kconfigwidgets
    kcoreaddons
    kdeclarative
    kglobalaccel
    ki18n
    libpulseaudio
    plasma-framework
  ];
}
