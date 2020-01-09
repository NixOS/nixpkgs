{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "primesieve";
  version = "7.5";

  nativeBuildInputs = [cmake];

  src = fetchurl {
    url = "https://github.com/kimwalisch/primesieve/archive/v${version}.tar.gz";
    sha256 = "0g60br3p8di92jx3pr2bb51xh15gg57l7qvwzwn7xf7l585hgi7v";
  };

  meta = with stdenv.lib; {
    description = "Fast C/C++ prime number generator";
    homepage = "https://primesieve.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
