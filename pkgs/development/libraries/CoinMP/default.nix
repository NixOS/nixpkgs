{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "CoinMP-${version}";
  version = "1.8.3";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/CoinMP/${name}.tgz";
    sha256 = "1xr2iwbbhm6l9hwiry5c10pz46xfih8bvzrzwp0nkzf76vdnb9m1";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://projects.coin-or.org/CoinMP/;
    description = "COIN-OR lightweight API for COIN-OR libraries CLP, CBC, and CGL";
    platforms = platforms.unix;
    license = licenses.epl10;
  };
}
