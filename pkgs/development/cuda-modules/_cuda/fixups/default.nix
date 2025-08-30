{ lib }:
lib.mapAttrs' (fileName: _type: {
  # Fixup is in `./${attrName}.nix` or in `./${fileName}/default.nix`:
  name = lib.removeSuffix ".nix" fileName;
  value = import (./. + "/${fileName}");
}) (builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ])
