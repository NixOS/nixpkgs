{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, json_glib, intltool, autoreconfHook, libraw
, libwebp, gnome3 }:

stdenv.mkDerivation rec {
  name = "gegl-0.3.24";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gegl/0.3/${name}.tar.bz2";
    sha256 = "0x4xjca05fbncy49vjs5nq3ria6j8wlpiq6yldkv0r6qcb18p80s";
  };

  hardeningDisable = [ "format" ];

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    babl libpng cairo libjpeg librsvg pango gtk bzip2 json_glib
    libraw libwebp gnome3.gexiv2
  ];

  nativeBuildInputs = [ pkgconfig intltool which autoreconfHook ];

  meta = {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = stdenv.lib.platforms.linux;
  };
}
