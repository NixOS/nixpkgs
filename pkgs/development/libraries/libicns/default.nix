{ stdenv, fetchurl, libpng, jasper }:

stdenv.mkDerivation rec {
  name = "libicns-0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/icns/${name}.tar.gz";
    sha256 = "1hjm8lwap7bjyyxsyi94fh5817xzqhk4kb5y0b7mb6675xw10prk";
  };

  buildInputs = [ libpng jasper ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
