{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, intltool }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "libgnome-games-support-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-games-support/1.2/${name}.tar.xz";
    sha256 = "1rsyf5hbjim7zpk1yar3gv65g1nmw6zbbc0smrmxsfk0f9n3j9m6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gtk3 libgee intltool ];

  meta = with stdenv.lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = https://github.com/GNOME/libgames-support;
    license = licenses.gpl3;
  };
}
