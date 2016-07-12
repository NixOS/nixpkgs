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
  patches = [ ./0001-follow-symlinks.patch ];
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    ki18n kio glib gtk2 gtk3 karchive kcmutils kconfigwidgets kiconthemes
    knewstuff
  ];
  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];
}
