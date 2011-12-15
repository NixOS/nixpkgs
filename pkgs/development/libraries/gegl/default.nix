{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg
, librsvg, pango, gtk, bzip2 }:
        
stdenv.mkDerivation rec {
  name = "gegl-0.1.6";

  src = fetchurl {
    url = "http://ftp.snt.utwente.nl/pub/software/gimp/gegl/0.1/${name}.tar.bz2";
    sha256 = "1l966ygss2zkksyw62nm139v2abfzbqqrj0psizvbgzf4mb24rm1";
  };

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  buildInputs = [ babl libpng cairo libjpeg librsvg pango gtk bzip2 ];

  buildNativeInputs = [ pkgconfig ];

  meta = { 
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = "GPL3";
  };
}
