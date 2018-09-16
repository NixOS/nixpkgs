{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, json-glib, intltool, autoreconfHook, libraw
, libwebp, gnome3, libintl }:

stdenv.mkDerivation rec {
  name = "gegl-0.3.34";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/0.3/${name}.tar.bz2";
    sha256 = "010k86wn8cmr07rqwa4lccrmiiqrwbnkxvic4lpapwgbamv258jw";
  };

  hardeningDisable = [ "format" ];

  # needs fonts otherwise  don't know how to pass them
  configureFlags = [ "--disable-docs" ];

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    libpng cairo libjpeg librsvg pango gtk bzip2
    libraw libwebp gnome3.gexiv2
  ];

  propagatedBuildInputs = [ glib json-glib babl ]; # for gegl-3.0.pc

  nativeBuildInputs = [ pkgconfig intltool which autoreconfHook libintl ];

  meta = with stdenv.lib; {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
