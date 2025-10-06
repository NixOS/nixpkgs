{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
in

with haskellLib;

(self: super: {
  # cabal2nix doesn't properly add dependencies conditional on os(windows)
  network =
    if pkgs.stdenv.hostPlatform.isWindows then
      addBuildDepends [ self.temporary ] super.network
    else
      super.network;
})
