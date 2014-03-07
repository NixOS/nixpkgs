{ stdenv, fetchurl, readline, gmp, zlib }:

stdenv.mkDerivation rec {
  version = "6.2.2";
  name = "yap-${version}";

  src = fetchurl {
    url = "http://www.dcc.fc.up.pt/~vsc/Yap/${name}.tar.gz";
    sha256 = "0l6p0vy667wws64cvwf74ssl6h9gypjzrsl3b2d32hs422186pzi";
  };

  buildInputs = [ readline gmp zlib ];

  configureFlags = "--enable-tabling=yes";

  meta = {
    homepage = "http://www.dcc.fc.up.pt/~vsc/Yap/";
    description = "Yap Prolog System is a ISO-compatible high-performance Prolog compiler";
    license = "artistic";

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
