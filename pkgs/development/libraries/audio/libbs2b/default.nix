{ stdenv, fetchurl, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  name = "libbs2b-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/bs2b/${name}.tar.bz2";
    sha256 = "0vz442kkjn2h0dlxppzi4m5zx8qfyrivq581n06xzvnyxi5rg6a7";
  };

  buildInputs = [ pkgconfig libsndfile ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://bs2b.sourceforge.net/;
    description = "Bauer stereophonic-to-binaural DSP library";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
