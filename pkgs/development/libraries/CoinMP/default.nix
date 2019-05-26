{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "CoinMP-${version}";
  version = "1.8.4";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/CoinMP/${name}.tgz";
    sha256 = "13d3j1sdcjzpijp4qks3n0zibk649ac3hhv88hkk8ffxrc6gnn9l";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://projects.coin-or.org/CoinMP/;
    description = "COIN-OR lightweight API for COIN-OR libraries CLP, CBC, and CGL";
    platforms = platforms.unix;
    license = licenses.epl10;
  };
}
