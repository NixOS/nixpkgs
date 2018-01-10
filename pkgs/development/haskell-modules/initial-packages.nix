args@{ pkgs, stdenv, callPackage }: self:
   (import ./hie-packages.nix args self) // (import ./hackage-packages.nix args self)
