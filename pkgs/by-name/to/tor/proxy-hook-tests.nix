{
  testers,
  fetchFromGitLab,
  fetchgit,
  fetchurl,
  fetchzip,
  linkFarm,
  tor,
}:
let
  domain = "eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion";
  rev = "933c5491db00c703d5d8264fdabd5a5b10aff96f";
  hash = "sha256-o6Wpso8GSlQH39GpH3IXZyrVhdP8pEYFxLDq9a7yHX0=";
in
linkFarm "tor-proxy-hook-tests" {
  fetchgit = testers.invalidateFetcherByDrvHash fetchgit {
    name = "fetchgit-tor-source";
    url = "http://${domain}/tpo/core/tor";
    inherit rev hash;
    nativeBuildInputs = [ tor.proxyHook ];
  };

  fetchzip = testers.invalidateFetcherByDrvHash fetchzip {
    name = "fetchzip-tor-source";
    url = "http://${domain}/tpo/core/tor/-/archive/${rev}/tor-${rev}.zip";
    inherit hash;
    nativeBuildInputs = [ tor.proxyHook ];
  };

  fetchurl = testers.invalidateFetcherByDrvHash fetchurl {
    name = "fetchurl-tor-source";
    url = "http://${domain}/tpo/core/tor/-/raw/${rev}/Cargo.lock";
    hash = "sha256-oX4WbsscLADgJ5o+czpueyAih7ic0u4lZQs7y1vMA3A=";
    nativeBuildInputs = [ tor.proxyHook ];
  };

  fetchFromGitLab = testers.invalidateFetcherByDrvHash fetchFromGitLab {
    name = "gitlab-tor-source";
    protocol = "http";
    owner = "tpo/core";
    repo = "tor";
    inherit domain rev hash;
    nativeBuildInputs = [ tor.proxyHook ];
  };
}
