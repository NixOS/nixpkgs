{ self, callPackage, lib, passthruFun }:
callPackage ./default.nix {
  sourceVersion = { major = "2"; minor = "0"; patch = "5"; };
  inherit self passthruFun;
  version = "2.0.5-2022-09-13";
  rev = "46e62cd963a426e83a60f691dcbbeb742c7b3ba2";
  isStable = true;
  hash = "sha256-/XR9+6NjXs2TrUVKJNkH2h970BkDNFqMDJTWcy/bswU=";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: !hasPrefix "aarch64-" p)
      (platforms.linux ++ platforms.darwin);
  };
}
