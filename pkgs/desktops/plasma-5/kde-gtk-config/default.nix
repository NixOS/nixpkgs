{
  mkDerivation,
  extra-cmake-modules,
  glib, gtk2, gtk3, karchive, kcmutils, kconfigwidgets, ki18n, kiconthemes, kio,
  knewstuff, gsettings-desktop-schemas
}:

mkDerivation {
  name = "kde-gtk-config";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    ki18n kio glib gtk2 gtk3 karchive kcmutils kconfigwidgets kiconthemes
    knewstuff gsettings-desktop-schemas
  ];
  patches = [ ./0001-follow-symlinks.patch ];
  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGLIB_SCHEMAS_DIR=${gsettings-desktop-schemas.out}/"
  ];
}
