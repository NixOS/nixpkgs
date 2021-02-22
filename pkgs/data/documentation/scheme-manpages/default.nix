{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages-unstable";
  version = "2021-01-17";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "817798ccca81424e797fda0e218d53a95f50ded7";
    sha256 = "1amc0dmliz2a37pivlkx88jbc08ypfiwv3z477znx8khhc538glk";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/man
    cp -r man3/ man7/ $out/share/man/
  '';

  meta = with lib; {
    description = "Unix manual pages for R6RS and R7RS";
    homepage = "https://github.com/schemedoc/manpages";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
