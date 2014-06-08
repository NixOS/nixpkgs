{ stdenv, fetchurl, pkgconfig, intltool
, glib, gtk3, gobjectIntrospection, python, pygobject3
}:

stdenv.mkDerivation rec {
  name = "libpeas-${version}";
  version = "1.10.0";

  buildInputs =  [
   intltool pkgconfig
   glib gtk3 gobjectIntrospection python pygobject3
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libpeas/1.10/${name}.tar.xz";
    sha256 = "4695bc40e4885a903dbc5ce6a3704392feae63af51fd4da7a3888bb88ca78c47";
  };

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = {
    description = "A GObject-based plugins engine";
    homepage = "http://ftp.acc.umu.se/pub/GNOME/sources/libpeas/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
