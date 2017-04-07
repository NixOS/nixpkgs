{ bootPkgs }:

bootPkgs.callPackage ./base.nix {
  inherit bootPkgs;
  broken = true; # http://hydra.nixos.org/build/45110274
}
