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
    glib kconfigwidgets kcoreaddons kglobalaccel ki18n libpulseaudio
    plasma-framework
  ];
  propagatedBuildInputs = [ kdeclarative ];
}
