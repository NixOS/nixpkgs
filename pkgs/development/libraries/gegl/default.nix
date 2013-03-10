{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg
, librsvg, pango, gtk, bzip2, intltool }:
        
stdenv.mkDerivation rec {
  name = "gegl-0.2.0";

  src = fetchurl {
    url = "ftp://ftp.gtk.org/pub/gegl/0.2/${name}.tar.bz2";
    sha256 = "df2e6a0d9499afcbc4f9029c18d9d1e0dd5e8710a75e17c9b1d9a6480dd8d426";
  };

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  buildInputs = [ babl libpng cairo libjpeg librsvg pango gtk bzip2 intltool ];

  nativeBuildInputs = [ pkgconfig ];

  meta = { 
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = "GPL3";
  };
}
