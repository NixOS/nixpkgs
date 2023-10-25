{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "functionalplus";
  version = "0.2.18-p0";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "FunctionalPlus";
    rev = "v${version}";
    sha256 = "sha256-jypBQjFdVEktB8Q71RTg+3RJoeFwD5Wxw+fq+4QG38g=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Functional Programming Library for C++";
    homepage = "https://github.com/Dobiasd/FunctionalPlus";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = [];
  };
}
