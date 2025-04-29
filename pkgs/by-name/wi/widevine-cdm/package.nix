{
  lib,
  stdenv,
  callPackage,
}:

let
  targets = lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
  ] (name: ./. + "/${name}.nix");
in
callPackage (targets."${stdenv.hostPlatform.system}" or targets.x86_64-linux) { inherit stdenv; }
