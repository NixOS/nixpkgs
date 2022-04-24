{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "primesieve";
  version = "7.8";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primesieve";
    rev = "v${version}";
    sha256 = "sha256-M35CP/xEyC7mEh84kaGsgfsDI9fnanHraNPgTvpqimI=";
  };

  meta = with lib; {
    description = "Fast C/C++ prime number generator";
    homepage = "https://primesieve.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
