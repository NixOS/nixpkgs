{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2022-03-13";
  rev = "93a65d3cc263aef2d2feb3d7ff2206aca3bee17e";
  isStable = true;
  hash = "sha256-Gp7OdfxBGkW59zxWUml2ugPABLUv2SezMiDblA/FZ7g=";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: !hasPrefix "aarch64-" p)
      (platforms.linux ++ platforms.darwin);
  };
}
