{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "CoinMP-${version}";
  version = "1.7.6";

  src = fetchurl {
    url = "http://www.coin-or.org/download/source/CoinMP/${name}.tgz";
    sha256 = "0gqi2vqkg35gazzzv8asnhihchnbjcd6bzjfzqhmj7wy1dw9iiw6";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://projects.coin-or.org/CoinMP/;
    description = "COIN-OR lightweight API for COIN-OR libraries CLP, CBC, and CGL";
    platforms = platforms.linux;
    license = licenses.epl10;
  };
}
