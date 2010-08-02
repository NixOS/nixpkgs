{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg
, librsvg, pango, gtk }:
        
stdenv.mkDerivation {
  name = "gegl-0.0.22";

  src = fetchurl {
    url = ftp://ftp.gimp.org/pub/gegl/0.0/gegl-0.0.22.tar.bz2;
    sha256 = "0nx6r9amzhw5d2ghlw3z8qnry18rwz1ymvl2cm31b8p49z436wl5";
  };

  configureFlags = "--disable-docs"; # needs fonts otherwise  don't know how to pass them

  buildInputs = [ pkgconfig glib babl libpng cairo libjpeg librsvg pango gtk ];

  meta = { 
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = "GPL3";
  };
}
