{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "smug-gerbil";
  version = "unstable-2019-12-24";
  git-version = "95d60d4";
  gerbil-package = "drewc/smug";
  gerbil = gerbil-unstable;
  gerbilInputs = [];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = ""; #"version";
  softwareName = "Smug-Gerbil";
  src = fetchFromGitHub {
    owner = "drewc";
    repo = "smug-gerbil";
    rev = "95d60d486c1603743c6d3c525e6d5f5761b984e5";
    sha256 = "0ys07z78gq60z833si2j7xa1scqvbljlx1zb32vdf32f1b27c04j";
  };
  meta = {
    description = "Super Monadic Über Go-into : Parsers and Gerbil Scheme";
    homepage    = "https://github.com/drewc/smug-gerbil";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
  buildScript = ''
    for i in primitive simple tokens smug ; do gxc -O $i.ss ; done
  '';
}
