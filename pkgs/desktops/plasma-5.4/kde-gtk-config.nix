{ plasmaPackage
, extra-cmake-modules
, glib
, gtk2
, gtk3
, karchive
, kcmutils
, kconfigwidgets
, ki18n
, kiconthemes
, kio
, knewstuff
}:

plasmaPackage {
  name = "kde-gtk-config";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    glib gtk2 gtk3 karchive kcmutils kconfigwidgets kiconthemes
    kio knewstuff
  ];
  propagatedBuildInputs = [ ki18n ];
  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include"
  ];
}
