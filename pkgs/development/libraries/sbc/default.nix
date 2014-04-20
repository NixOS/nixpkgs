{ stdenv, fetchurl, libsndfile, pkgconfig }:

stdenv.mkDerivation rec {
  name = "sbc-1.1";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/bluetooth/${name}.tar.xz";
    sha256 = "1ipvkhilyhdbd2nzq0la6l7q361l0zm0c6kvga2a0y89q8nssc4s";
  };

  buildInputs = [ pkgconfig libsndfile ];

  meta = {
    description = "SubBand Codec Library";

    homepage = http://www.bluez.org/;

    license = stdenv.lib.licenses.gpl2;
  };
}
