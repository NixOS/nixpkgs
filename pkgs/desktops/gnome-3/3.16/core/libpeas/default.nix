{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, glib, gtk3, gobjectIntrospection, python, pygobject3
}:

let
  majorVersion = "1.12";
in
stdenv.mkDerivation rec {
  name = "libpeas-${version}";
  version = "${majorVersion}.1";

  buildInputs =  [
   intltool pkgconfig glib gtk3 gobjectIntrospection python pygobject3
   gnome3.defaultIconTheme
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libpeas/${majorVersion}/${name}.tar.xz";
    sha256 = "e610be31c9d382580fb5d8686f8311149f27413f55af6abf5c033178b99452d6";
  };

  preFixup = ''
  '';

  meta = with stdenv.lib; {
    description = "A GObject-based plugins engine";
    homepage = "http://ftp.acc.umu.se/pub/GNOME/sources/libpeas/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
