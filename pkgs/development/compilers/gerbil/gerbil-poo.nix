{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-ethereum";
  version = "unstable-2020-08-02";
  git-version = "0.0-13-g1014154";
  gerbil-package = "clan/poo";
  gerbil = gerbil-unstable;
  gerbilInputs = with gerbil-support.gerbilPackages-unstable; [gerbil-utils gerbil-crypto];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-POO";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-poo";
    rev = "1014154fe4943dfbec7524666c831b601ba88559";
    sha256 = "0g8l5mi007n07qs79m9h3h3am1p7h0kzq7yb49h562b8frh5gp97";
  };
  meta = {
    description = "Gerbil POO: Prototype Object Orientation for Gerbil Scheme";
    homepage    = "https://github.com/fare/gerbil-poo";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
