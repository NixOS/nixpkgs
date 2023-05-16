<<<<<<< HEAD
{ lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-poo";
  version = "unstable-2023-04-28";
  git-version = "0.0-106-g418b582";
  softwareName = "Gerbil-POO";
  gerbil-package = "clan/poo";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [ gerbil-utils ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-poo";
    rev = "418b582ae72e1494cf3a5f334d31d4f6503578f5";
    sha256 = "0qdzs7l6hp45dji5bc3879k4c8k9x6cj4qxz68cskjhn8wrc5lr8";
  };

  meta = with lib; {
    description = "Gerbil POO: Prototype Object Orientation for Gerbil Scheme";
    homepage    = "https://github.com/fare/gerbil-poo";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
=======
{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-ethereum";
  version = "unstable-2020-10-17";
  git-version = "0.0-35-g44d490d";
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
    rev = "44d490d95b9d1b5d54eaedf2602419af8e086837";
    sha256 = "082ndpy281saybcnp3bdidcibkk2ih6glrkbb5fdj1524ban4d0k";
  };
  meta = {
    description = "Gerbil POO: Prototype Object Orientation for Gerbil Scheme";
    homepage    = "https://github.com/fare/gerbil-poo";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
