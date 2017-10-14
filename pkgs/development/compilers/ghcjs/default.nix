{ bootPkgs }:

bootPkgs.callPackage ./base.nix {
  inherit bootPkgs;
  broken = true;  # https://hydra.nixos.org/build/62184741
}
