{ lib, config, ... }:
let
  inherit (lib)
    trivial
    types
    ;
in
{
  options.generic.manifests = {
    feature = import ./feature/manifest.nix { inherit lib config; };

    redistrib = lib.mkOption {
      description = "Redistributable manifest is an attribute set which includes a mapping from package name to release";
      example = trivial.importJSON ../../../cuda/manifests/redistrib_11.5.2.json;
      type = types.submodule (import ./redistrib/manifest.nix { inherit lib; });
    };
  };
}
