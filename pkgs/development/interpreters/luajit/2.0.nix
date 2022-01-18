{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5-2021-10-02";
  rev = "d3294fa63b344173db68dd612c6d3801631e28d4";
  isStable = true;
  sha256 = "0ja6x7bv3iqnf6m8xk6qp1dgan2b7mys0ff86dw671fqqrfw28fn";
  extraMeta = { # this isn't precise but it at least stops the useless Hydra build
    platforms = with lib; filter (p: !hasPrefix "aarch64-" p)
      (platforms.linux ++ platforms.darwin);
  };
}
