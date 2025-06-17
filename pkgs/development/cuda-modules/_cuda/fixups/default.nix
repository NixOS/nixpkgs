{ lib }:
lib.concatMapAttrs (
  fileName: _type:
  let
    # Fixup is in `./${attrName}.nix` or in `./${fileName}/default.nix`:
    attrName = lib.removeSuffix ".nix" fileName;
    fixup = import (./. + "/${fileName}");
    isFixup = fileName != "default.nix";
  in
  lib.optionalAttrs isFixup { ${attrName} = fixup; }
) (builtins.readDir ./.)
