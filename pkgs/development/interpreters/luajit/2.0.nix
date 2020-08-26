{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2020-08-05";
  rev = "2211f6f";
  isStable = true;
  sha256 = "01adxmknq2xyb3w9sn8ilnar8181h7ksd9i80yrsbwzix5lwkn6m";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
