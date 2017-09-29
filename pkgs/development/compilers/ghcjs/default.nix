{ bootPkgs }:

bootPkgs.callPackage ./base.nix {
  inherit bootPkgs;
  broken = false;
}
