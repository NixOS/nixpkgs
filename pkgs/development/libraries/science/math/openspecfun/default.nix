{ lib, stdenv, fetchFromGitHub, gfortran }:

stdenv.mkDerivation rec {
  pname = "openspecfun";
  version = "0.5.3";
  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openspecfun";
    rev = "v${version}";
    sha256 = "0pfw6l3ch7isz403llx7inxlvavqh01jh1hb9dpidi86sjjx9kfh";
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
