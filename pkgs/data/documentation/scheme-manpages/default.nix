{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2023-02-06";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "ccaa76761a1b100e99287c120196bd5f32d4a403";
    hash = "sha256-RL/94dQiZJ60cXHQ9r4P3hRBqe55oUissCmSp4XLM+o=";
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
