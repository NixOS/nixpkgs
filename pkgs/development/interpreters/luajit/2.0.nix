{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2021-07-27";
  rev = "3a654999c6f00de4cb9e61232d23579442e544a0";
  isStable = true;
  sha256 = "0q187vn6bspn9i33hrvfy59mh83nd8jjmik5qkkkc3vls13jxr6z";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: !hasPrefix "aarch64-" p)
      (platforms.linux ++ platforms.darwin);
  };
}
