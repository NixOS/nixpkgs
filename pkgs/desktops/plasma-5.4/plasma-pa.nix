{ plasmaPackage, extra-cmake-modules, glib, kconfigwidgets
, kcoreaddons, kdeclarative, kglobalaccel, ki18n, libpulseaudio
, plasma-framework
}:

plasmaPackage {
  name = "plasma-pa";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    glib kconfigwidgets kcoreaddons libpulseaudio
  ];
  propagatedBuildInputs = [
    kdeclarative kglobalaccel ki18n plasma-framework
  ];
}
