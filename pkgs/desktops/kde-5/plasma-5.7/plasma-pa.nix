{ plasmaPackage, extra-cmake-modules, glib, kdoctools, kconfigwidgets
, kcoreaddons, kdeclarative, kglobalaccel, ki18n, libpulseaudio
, plasma-framework
}:

plasmaPackage {
  name = "plasma-pa";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    glib kconfigwidgets kcoreaddons libpulseaudio kdeclarative kglobalaccel
    ki18n plasma-framework
  ];
}
