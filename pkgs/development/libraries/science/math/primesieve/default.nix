{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "primesieve";
  version = "7.4";

  nativeBuildInputs = [cmake];

  src = fetchurl {
    url = "https://github.com/kimwalisch/primesieve/archive/v${version}.tar.gz";
    sha256 = "16930d021ai8cl3gsnn2v6l30n6mklwwqd53z51cddd3dj69x6zz";
  };

  meta = with stdenv.lib; {
    description = "Fast C/C++ prime number generator";
    homepage = "https://primesieve.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
