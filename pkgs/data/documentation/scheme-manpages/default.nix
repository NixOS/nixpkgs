{ lib, stdenvNoCC, fetchFromGitHub, unstableGitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2023-06-04";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "d5fce963985df270cb99d020169b4f28122e6415";
    hash = "sha256-snODSEtH1K/X0MakJWcPM40cqLUA+0cbBkhAHuisCyI=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/man
    cp -r man3/ man7/ $out/share/man/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Unix manual pages for R6RS and R7RS";
    homepage = "https://github.com/schemedoc/manpages";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
