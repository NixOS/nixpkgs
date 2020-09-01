{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2020-08-09";
  rev = "e296f56";
  isStable = true;
  sha256 = "0g4wvpmmrxj8ir6yi86gg93khy8ri7x4w091jihpxsmn670da21f";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
