{ self, callPackage, fetchFromGitHub, lib, passthruFun }:

callPackage ./default.nix {
  version = "2.0.5-2022-09-13";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "46e62cd963a426e83a60f691dcbbeb742c7b3ba2";
    hash = "sha256-/XR9+6NjXs2TrUVKJNkH2h970BkDNFqMDJTWcy/bswU=";
  };

  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: !hasPrefix "aarch64-" p)
      (platforms.linux ++ platforms.darwin);
  };
  inherit self passthruFun;
}
