{ stdenv, fetchurl, pkgconfig, freetype, fontconfig, libpng, libjpeg
, libX11, libXext, eina, eet }:
stdenv.mkDerivation rec {
  name = "evas-${version}";
  version = "1.1.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "1qjmxn5a5qhc2slxjx7bsas76w0zlnrbs6hx9swr8xarkifjk3dv";
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
