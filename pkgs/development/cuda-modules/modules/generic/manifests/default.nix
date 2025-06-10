{ lib, config, ... }:
let
  inherit (lib)
    trivial
    types
    ;
in
{
  options.generic.manifests = {
    feature = lib.mkOption {
      description = "Feature manifest is an attribute set which includes a mapping from package name to release";
      example = trivial.importJSON ../../../cuda/manifests/feature_11.5.2.json;
      type = types.submodule { imports = [ ./feature/manifest.nix ]; };
    };

    redistrib = lib.mkOption {
      description = "Redistributable manifest is an attribute set which includes a mapping from package name to release";
      example = trivial.importJSON ../../../cuda/manifests/redistrib_11.5.2.json;
      type = types.submodule { imports = [ ./redistrib/manifest.nix ]; };
    };
  };
}
