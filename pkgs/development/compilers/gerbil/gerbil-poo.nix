{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:
{
  pname = "gerbil-poo";
  gerbil-package = "clan/poo";
  version = "unstable-2020-10-17";
  git-version = "0.0-35-g44d490d";
  gerbil = gerbil-unstable;
  gerbilInputs = with gerbil-support.gerbilPackages-unstable; [gerbil-utils gerbil-crypto];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-POO";
  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-poo";
    rev = "44d490d95b9d1b5d54eaedf2602419af8e086837";
    sha256 = "082ndpy281saybcnp3bdidcibkk2ih6glrkbb5fdj1524ban4d0k";
  };
  meta = {
    description = "Gerbil POO: Prototype Object Orientation for Gerbil Scheme";
    homepage    = "https://github.com/fare/gerbil-poo";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
