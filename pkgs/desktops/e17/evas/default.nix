{ stdenv, fetchurl, pkgconfig, freetype, fontconfig, libpng, libjpeg
, libX11, libXext, eina, eet }:
stdenv.mkDerivation rec {
  name = "evas-${version}";
  version = "1.2.0-alpha";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "1lyya0nc8p0vs63azkflwq7lqqml94cqzjpg12h43sbvza342rsq";
  };
  buildInputs = [ pkgconfig freetype fontconfig libpng libjpeg
                  libX11 libXext eina eet
                ];
  meta = {
    description = "Enlightenment's canvas and scenegraph rendering library";
    longDescription = ''
      Enlightenment's Evas is a clean display canvas API that
      implements a scene graph, not an immediate-mode rendering
      target, is cross-platform, for several target display systems
      that can draw anti-aliased text, smooth super and sub-sampled
      scaled images, alpha-blend objects and much more.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
