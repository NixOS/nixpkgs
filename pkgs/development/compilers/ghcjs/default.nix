{ bootPkgs, cabal-install }:

bootPkgs.callPackage ./base.nix {
  inherit bootPkgs cabal-install;
  broken = true;  # https://hydra.nixos.org/build/70552553
}
