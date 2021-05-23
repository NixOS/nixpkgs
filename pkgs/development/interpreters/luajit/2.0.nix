{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2021-05-17";
  rev = "44684fa71d8af6fa8b3051c7d763bbfdcf7915d7";
  isStable = true;
  sha256 = "049d3l0miv4n0cnm35ml8flrb9vs12zvbda2743vypckymidliqp";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
