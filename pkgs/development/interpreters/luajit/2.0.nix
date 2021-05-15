{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2020-12-28";
  rev = "56c04accf975bff2519c34721dccbbdb7b8e6963";
  isStable = true;
  sha256 = "0mmx7dy843iqdpyxxdfks860np0311gg58gi4zczx10h62y6jacm";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
