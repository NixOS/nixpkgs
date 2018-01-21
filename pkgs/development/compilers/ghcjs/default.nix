{ bootPkgs, cabal-install }:

bootPkgs.callPackage ./base.nix {
  inherit bootPkgs cabal-install;
}
