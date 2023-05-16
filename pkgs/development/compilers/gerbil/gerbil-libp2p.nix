<<<<<<< HEAD
{ lib, fetchFromGitHub, ... }:

{
  pname = "gerbil-libp2p";
  version = "unstable-2022-02-03";
  git-version = "15b3246";
  softwareName = "Gerbil-libp2p";
  gerbil-package = "vyzo";

  buildInputs = []; # Note: at *runtime*, this depends on go-libp2p-daemon running

  pre-src = {
    fun = fetchFromGitHub;
    owner = "vyzo";
    repo = "gerbil-libp2p";
    rev = "15b32462e683d89ffce0ff15ad373d293ea0ee5d";
    sha256 = "059lydp7d6pjgrd4pdnqq2zffzlba62ch102f01rgzf9aps3c8lz";
  };

  meta = with lib; {
    description = "Gerbil libp2p: use libp2p from Gerbil";
    homepage    = "https://github.com/vyzo/gerbil-libp2p";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
=======
{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-libp2p";
  version = "unstable-2018-12-27";
  git-version = "2376b3f";
  gerbil-package = "vyzo";
  gerbil = gerbil-unstable;
  gerbilInputs = [];
  buildInputs = []; # Note: at *runtime*, depends on go-libp2p-daemon
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-libp2p";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil-libp2p";
    rev = "2376b3f39cee04dd4ec455c8ea4e5faa93c2bf88";
    sha256 = "0jcy7hfg953078msigyfwp2g4ii44pi6q7vcpmq01cbbvxpxz6zw";
  };
  meta = {
    description = "Gerbil libp2p: use libp2p from Gerbil";
    homepage    = "https://github.com/vyzo/gerbil-libp2p";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
