{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2020-03-20";
  rev = "e613105";
  isStable = true;
  sha256 = "0k843z90s4hi0qhri6ixy8sv21nig8jwbznpqgqg845ji530kqj7";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: p != "aarch64-linux")
      (platforms.linux ++ platforms.darwin);
  };
}
