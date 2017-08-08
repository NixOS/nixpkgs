{ bootPkgs, nodejs }:

bootPkgs.callPackage ./base.nix {
  inherit bootPkgs nodejs;
  broken = false;
}
