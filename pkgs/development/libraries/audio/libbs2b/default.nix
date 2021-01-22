{ lib, stdenv, fetchurl, pkg-config, libsndfile }:

stdenv.mkDerivation rec {
  pname = "libbs2b";
  version = "3.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/bs2b/${pname}-${version}.tar.bz2";
    sha256 = "0vz442kkjn2h0dlxppzi4m5zx8qfyrivq581n06xzvnyxi5rg6a7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://bs2b.sourceforge.net/";
    description = "Bauer stereophonic-to-binaural DSP library";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
