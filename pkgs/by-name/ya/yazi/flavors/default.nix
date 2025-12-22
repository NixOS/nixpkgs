{
  lib,
  callPackage,
}:
let
  root = ./.;
  call = name: callPackage (root + "/${name}") { };
in
lib.pipe root [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: _: call name))
]
