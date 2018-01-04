{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, json_glib, intltool, autoreconfHook, libraw
, libwebp, gnome3 }:

stdenv.mkDerivation rec {
  name = "gegl-0.3.26";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gegl/0.3/${name}.tar.bz2";
    sha256 = "1a9zbi6ws0r0sqynvg2fh3ad0ipnphg7w62y7whlcrbpqi29izvf";
  };

  hardeningDisable = [ "format" ];

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    libpng cairo libjpeg librsvg pango gtk bzip2
    libraw libwebp gnome3.gexiv2
  ];

  propagatedBuildInputs = [ glib json_glib babl ]; # for gegl-3.0.pc

  nativeBuildInputs = [ pkgconfig intltool which autoreconfHook ];

  meta = {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = stdenv.lib.platforms.linux;
  };
}
