{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "primesieve";
  version = "7.6";

  nativeBuildInputs = [cmake];

  src = fetchurl {
    url = "https://github.com/kimwalisch/primesieve/archive/v${version}.tar.gz";
    sha256 = "sha256-SFZp6Pmmx05SiUfSdN9wXxPKrydtRg0PA3uNvAycCpk=";
  };

  meta = with lib; {
    description = "Fast C/C++ prime number generator";
    homepage = "https://primesieve.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
