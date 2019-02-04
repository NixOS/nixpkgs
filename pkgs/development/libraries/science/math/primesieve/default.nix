{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "primesieve-${version}";
  version = "7.3";

  nativeBuildInputs = [cmake];

  src = fetchurl {
    url = "https://github.com/kimwalisch/primesieve/archive/v${version}.tar.gz";
    sha256 = "0l7h5r4c7hijh0c0nsdxvjqzc9dbhlx535b87fglf2i2p9la1x5v";
  };

  meta = with stdenv.lib; {
    description = "Fast C/C++ prime number generator";
    homepage = "https://primesieve.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
