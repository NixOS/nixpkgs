{ plasmaPackage, ecm, glib, kdoctools, kconfigwidgets
, kcoreaddons, kdeclarative, kglobalaccel, ki18n, libpulseaudio
, plasma-framework
}:

plasmaPackage {
  name = "plasma-pa";
  nativeBuildInputs = [
    ecm
    kdoctools
  ];
  propagatedBuildInputs = [
    glib kconfigwidgets kcoreaddons libpulseaudio kdeclarative kglobalaccel
    ki18n plasma-framework
  ];
}
