{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobjectIntrospection, cairo
, libarchive, freetype, libjpeg, libtiff
}:

stdenv.mkDerivation rec {
  name = "libgxps-0.3.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgxps/0.3/${name}.tar.xz";
    sha256 = "412b1343bd31fee41f7204c47514d34c563ae34dafa4cc710897366bd6cd0fae";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection ];
  buildInputs = [ glib cairo freetype libjpeg libtiff ];
  propagatedBuildInputs = [ libarchive ];

  mesonFlags = [
    "-Denable-test=false"
    "-Dwith-liblcms2=false"
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
