{ fetchurl, stdenv, pkgconfig, intltool, gettext, glib, libxml2, zlib, bzip2
, python, gdk_pixbuf, libiconv, libintlOrEmpty }:

with { inherit (stdenv.lib) optionals; };

stdenv.mkDerivation rec {
  name = "libgsf-1.14.30";

  src = fetchurl {
    url    = "mirror://gnome/sources/libgsf/1.14/${name}.tar.xz";
    sha256 = "0w2v1a9sxsymd1mcy4mwsz4r6za9iwq69rj86nb939p41d4c6j6b";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gettext bzip2 zlib python ];

  propagatedBuildInputs = [ libxml2 glib gdk_pixbuf libiconv ]
    ++ libintlOrEmpty;

  doCheck = true;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = with stdenv.lib; {
    description = "GNOME's Structured File Library";
    homepage    = http://www.gnome.org/projects/libgsf;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
}
