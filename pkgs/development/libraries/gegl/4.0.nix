{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, which
, librsvg, pango, gtk, bzip2, json-glib, intltool, autoreconfHook, libraw
, libwebp, gnome3, libintl }:

let
  version = "0.4.0";
in stdenv.mkDerivation rec {
  name = "gegl-${version}";

  src = fetchurl {
    url = "http://download.gimp.org/pub/gegl/${stdenv.lib.versions.majorMinor version}/${name}.tar.bz2";
    sha256 = "1ighk4z8nlqrzyj8w97s140hzj59564l3xv6fpzbr97m1zx2nkfh";
  };

  # needs fonts otherwise, don't know how to pass them
  configureFlags = [ "--disable-docs" ];

  enableParallelBuilding = true;

  doCheck = true;

  buildInputs = [
    libpng cairo libjpeg librsvg pango gtk bzip2
    libraw libwebp gnome3.gexiv2
  ];

  propagatedBuildInputs = [ glib json-glib babl ]; # for gegl-4.0.pc

  nativeBuildInputs = [ pkgconfig intltool which autoreconfHook libintl ];

  meta = with stdenv.lib; {
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
