{ lib, stdenv, fetchFromGitHub, gfortran }:

stdenv.mkDerivation rec {
  pname = "openspecfun";
  version = "0.5.5";
  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openspecfun";
    rev = "v${version}";
    sha256 = "sha256-fX2wc8LHUcF5nN/hiA60ZZ7emRTs0SznOm/0q6lD+Ko=";
  };

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ gfortran ];

  meta = {
    description = "A collection of special mathematical functions";
    homepage = "https://github.com/JuliaLang/openspecfun";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.all;
  };
}
