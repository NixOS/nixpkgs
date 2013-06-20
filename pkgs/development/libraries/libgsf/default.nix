{ fetchurl, stdenv, pkgconfig, intltool, gettext, glib, libxml2, zlib, bzip2
, python, gdk_pixbuf, libiconvOrEmpty
}:

with { inherit (stdenv.lib) optionals; };

stdenv.mkDerivation rec {
  name = "libgsf-1.14.26";

  src = fetchurl {
    url = "mirror://gnome/sources/libgsf/1.14/${name}.tar.xz";
    sha256 = "1md67l60li7rkma9m6mwchqz6b6q4xsfr38c6n056y6xm8jyf6c9";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ gettext bzip2 zlib python ];

  propagatedBuildInputs = [ libxml2 glib gdk_pixbuf ] ++ libiconvOrEmpty;

  doCheck = true;

  meta = {
    homepage = http://www.gnome.org/projects/libgsf;
    license = "LGPLv2";
    description = "GNOME's Structured File Library";

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
