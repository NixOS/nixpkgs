{ lib, stdenvNoCC, fetchFromGitHub, unstableGitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2023-08-27";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "44317b20616699b13b2b6276c86d796f4ae0c8dd";
    hash = "sha256-qxj9sEQYOZ+me2IhDS5S2GRSho4KWWrEm+5MNxfw1VI=";
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
