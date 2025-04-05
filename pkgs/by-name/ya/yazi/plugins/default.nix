{ lib, callPackage }:
lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: _: callPackage ./${name} { }))
]
