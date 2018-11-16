args@{ pkgs, stdenv, callPackage }: self:
   (import ./hackage-packages.nix args self)
