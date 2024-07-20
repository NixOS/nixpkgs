{ self, callPackage, fetchFromGitHub, lib, passthruFun }:

callPackage ./default.nix {
  # The patch version is the timestamp of the git commit,
  # obtain via `cat $(nix-build -A luajit_2_0.src)/.relver`
  version = "2.0.1713483859";

  src = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = "9b5e837ac2dfdc0638830c048a47ca9378c504d3";
    hash = "sha256-GflF/sELSNanc9G4WMzoOadUBOFSs6OwqhAXa4sudWA=";
  };

  extraMeta = {
    # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: !hasPrefix "aarch64-" p)
      (platforms.linux ++ platforms.darwin);
  };
  inherit self passthruFun;
}
