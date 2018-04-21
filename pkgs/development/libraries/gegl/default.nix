{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg
, librsvg, pango, gtk2, bzip2, intltool, libintl
, OpenGL ? null }:

stdenv.mkDerivation rec {
  name = "gegl-0.2.0";

  src = fetchurl {
    url = "ftp://ftp.gtk.org/pub/gegl/0.2/${name}.tar.bz2";
    sha256 = "df2e6a0d9499afcbc4f9029c18d9d1e0dd5e8710a75e17c9b1d9a6480dd8d426";
  };

  patches = [( fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/"
      + "gegl-0.2.0-CVE-2012-4433.patch?h=packages/gegl&id=57a60fbda5d7bbbd1cc4767cb0724baa80c5e3e9";
    sha256 = "0p8mxj3w09nn1cc6cbxrd9hx742c5y27903i608wx6ja3kdjis59";
    name = "CVE-2012-4433.patch";
  })];

  # needs fonts otherwise  don't know how to pass them
  configureFlags = "--disable-docs";

  buildInputs = [ babl libpng cairo libjpeg librsvg pango gtk2 bzip2 intltool libintl ]
    ++ stdenv.lib.optional stdenv.isDarwin OpenGL;

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
