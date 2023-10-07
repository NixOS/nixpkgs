{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openlibm";
    rev = "v${version}";
    sha256 = "sha256-q7BYUU8oChjuBFbVnpT+vqIAu+BVotT4xY2Dn0hmWfc=";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = "https://openlibm.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.all;
  };
}
