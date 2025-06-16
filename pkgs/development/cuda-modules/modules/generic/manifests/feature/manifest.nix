{ lib, ... }:
let
  inherit (lib) types;
  inherit (types) attrsOf submodule;
  outputsOption = import ./outputs.nix { inherit lib; };
in
{
  freeformType = attrsOf (
    attrsOf (submodule {
      options.outputs = outputsOption;
      _file = ./outputs.nix;
    })
  );
}
