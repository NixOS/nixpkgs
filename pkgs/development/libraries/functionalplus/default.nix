{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "functionalplus";
  version = "0.2.25";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "FunctionalPlus";
    rev = "v${version}";
    sha256 = "sha256-eKCOi5g8YdKgxaI/mLlqB2m1zwrU9DOSrQF+PW2DBBQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Functional Programming Library for C++";
    homepage = "https://github.com/Dobiasd/FunctionalPlus";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
