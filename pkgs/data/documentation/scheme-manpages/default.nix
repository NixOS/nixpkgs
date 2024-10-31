{ lib, stdenvNoCC, fetchFromGitHub, unstableGitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "scheme-manpages";
  version = "0-unstable-2024-02-11";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "1ef440525db569799774c83634d28bfa630358da";
    hash = "sha256-ZBovG9i0qKD6dP4qcLP1T1fke0hC8MmRjZRzxuojd60=";
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
    maintainers = [ ];
    platforms = platforms.all;
  };
}
