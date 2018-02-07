{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, intltool }:

stdenv.mkDerivation rec {
  version = "1.2.3";
  name = "libgnome-games-support-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-games-support/1.2/${name}.tar.xz";
    sha256 = "1vwad7kqy7yd6wqyr71nq0blh7m53r3lz6ya16dmh942kd0w48v1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gtk3 libgee intltool ];

  meta = with stdenv.lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = https://github.com/GNOME/libgames-support;
    license = licenses.gpl3;
  };
}
