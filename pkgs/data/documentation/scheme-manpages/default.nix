{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2022-07-04";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "0b95de112857b185b83141ac9324fb0e786c56df";
    sha256 = "sha256-HWkZJd4t7gsbbSGiQ92Lav9EMBPMLXmXFT6HVfyFLSI=";
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
