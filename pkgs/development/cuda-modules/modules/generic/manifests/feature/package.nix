{ lib, ... }:
let
  inherit (lib) options types;
  Outputs = import ./outputs.nix { inherit lib; };
in
options.mkOption {
  description = "A package in the manifest";
  example = (import ./release.nix { inherit lib; }).linux-x86_64;
  type = types.submodule { options.outputs = Outputs; };
}
