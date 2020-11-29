{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:
{
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
  pre-src = {
    fun = fetchFromGitHub;
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
  };
}
