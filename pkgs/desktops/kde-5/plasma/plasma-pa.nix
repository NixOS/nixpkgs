{
  plasmaPackage,
  ecm,
  gconf, glib, kdoctools, kconfigwidgets, kcoreaddons, kdeclarative, kglobalaccel,
  ki18n, libcanberra_gtk3, libpulseaudio, plasma-framework
}:

plasmaPackage {
  name = "plasma-pa";
  nativeBuildInputs = [
    ecm kdoctools
  ];
  propagatedBuildInputs = [
    gconf glib kconfigwidgets kcoreaddons kdeclarative
    kglobalaccel ki18n libcanberra_gtk3 libpulseaudio plasma-framework
  ];
}
