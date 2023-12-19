{ config, lib, ... }:
let
  inherit (lib) filesystem options types;
  cfg = config.generic.manifests;
in
{
  options.cutensor = {
    # TODO(@connorbaker): Figure out how to move these general options into `generic.manifests.options`
    # and re-use them here, ideally overriding only the default values to get the effects we want.
    manifestPathParser = options.mkOption {
      description = "Function to parse a manifest path into a manifest";
      default = cfg.utils.manifestPathToManifestMeta;
      type = types.functionTo cfg.types.manifestMeta;
    };
    manifestPaths = options.mkOption {
      description = "List of paths to CUDA redistributable manifests";
      default = filesystem.listFilesRecursive ./manifests;
      type = types.listOf types.path;
    };
    manifestMetas = options.mkOption {
      description = "List of meta information about CUDA redistributable manifests";
      default = builtins.map cfg.utils.manifestPathToManifestMeta config.cutensor.manifestPaths;
      type = types.listOf cfg.types.manifestMeta;
    };
    manifestMetasToManifests = options.mkOption {
      description = "Function to convert a list of manifest metas to a list of manifests";
      default = cfg.utils.manifestMetasToManifests;
      type = types.functionTo cfg.types.manifests;
    };
    manifests = options.mkOption {
      description = "Mapping of manifest version (major and minor) to feature and redistributable manifests";
      default = cfg.utils.manifestMetasToManifests config.cutensor.manifestMetas;
      type = cfg.types.manifests;
    };
    fixupFns = options.mkOption {
      description = ''
        Functions to pass to a derivation's overrideAttrs function to perform fixup after being callPackage'd
      '';
      default = { };
      type = types.submodule {
        options = {
          generalFixupFn = options.mkOption {
            description = ''
              A general fixup applied to all redistributables's.

              NOTE: The value must be inspectable by `callPackage`. It seems that when functions are exposed via module
              configurations, they do not preserve functionArgs, and so callPackage will fail because it cannot supply
              arguments by default.
            '';
            default = ./fixup.nix;
            type = types.path;
          };
        };
      };
    };
  };
}
