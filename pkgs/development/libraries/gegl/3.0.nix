{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, intltool, libtool, automake, autoconf, json_glib }:

stdenv.mkDerivation rec {
  name = "gegl-0.3.6";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gegl/0.3/${name}.tar.bz2";
    sha256 = "08m7dlf2kwmp7jw3qskwxas192swhn1g4jcd8aldg9drfjygprvh";
  };

  configureScript = "./autogen.sh";

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  buildInputs = [ babl libpng cairo libjpeg librsvg pango gtk bzip2 intltool
                  autoconf automake libtool which json_glib ];

  nativeBuildInputs = [ pkgconfig ];

  meta = { 
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = stdenv.lib.licenses.gpl3;
  };
}
