{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2020-09-27";
  rev = "e8ec6fe";
  isStable = true;
  sha256 = "0v7g216j0zrjp32nfjqqxzgxgvgbdx89h3x0djbqg3avsgxjwnbk";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
