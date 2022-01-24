{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "primesieve";
  version = "7.7";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primesieve";
    rev = "v${version}";
    sha256 = "sha256-1Gfo00yaf7zHzCLfu/abWqeM0qBuLu+f+lowFFnWFxY=";
  };

  meta = with lib; {
    description = "Fast C/C++ prime number generator";
    homepage = "https://primesieve.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
