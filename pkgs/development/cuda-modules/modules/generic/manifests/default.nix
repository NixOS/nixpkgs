{ lib, config, ... }:
let
  inherit (lib)
    attrsets
    lists
    options
    trivial
    types
    versions
    ;
in
{
  options.generic.manifests = {
    utils = {
      manifestPathToManifestMeta = options.mkOption {
        type = types.functionTo config.generic.manifests.types.manifestMeta;
        description = "A function that takes a path to a manifest file and returns a manifestMeta";
        default =
          filename:
          let
            regex = "^.*(feature|redistrib)_([[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+)\\.json$";
            components = builtins.match regex (builtins.baseNameOf filename);
          in
          trivial.throwIf (components == null || builtins.length components != 2)
            "Unexpected error while processing manifest files: regex failed to match filename ${builtins.toString filename}"
            {
              path = filename;
              kind = builtins.head components;
              version = versions.majorMinor (lists.last components);
            };
      };
      manifestMetasToManifests = options.mkOption {
        type = types.functionTo config.generic.manifests.types.manifests;
        description = "A function that takes a list of manifestMeta an attribute set of manifest version to manifests";
        default =
          builtins.foldl'
            (
              manifests: manifestMeta:
              let
                inherit (manifestMeta) version kind path;
                nullableExistingEntry =
                  attrsets.attrByPath
                    [
                      version
                      kind
                    ]
                    null
                    manifests;

                newEntry =
                  attrsets.setAttrByPath
                    [
                      version
                      kind
                    ]
                    (
                      trivial.throwIf (nullableExistingEntry != null)
                        "Unexpected error while processing manifest files: duplicate version ${version}"
                        (trivial.importJSON path)
                    );
              in
              attrsets.recursiveUpdate manifests newEntry
            )
            { };
      };
    };
    options = {
      manifestPathParser = options.mkOption {
        description = "Function to parse a manifest path into a manifest";
        default = config.generic.manifests.utils.manifestPathToManifestMeta;
        type = types.functionTo config.generic.manifests.types.manifestMeta;
      };
      manifestPaths = options.mkOption {
        description = "List of paths to CUDA redistributable manifests";
        type = types.listOf types.path;
      };
      manifestMetas = options.mkOption {
        description = "List of meta information about CUDA redistributable manifests";
        type = types.listOf config.generic.manifests.types.manifestMeta;
      };
      manifestMetasToManifests = options.mkOption {
        description = "Function to convert a list of manifest metas to a list of manifests";
        default = config.generic.manifests.utils.manifestMetasToManifests;
        type = types.functionTo config.generic.manifests.types.manifests;
      };
      manifests = options.mkOption {
        description = "Mapping of manifest version (major and minor) to feature and redistributable manifests";
        type = config.generic.manifests.types.manifests;
      };
      generalFixupFn = options.mkOption {
        description = ''
          A general fixup applied to all redistributables's. Note that it requires `callPackage` to provide a
          `manifests` argument.
          NOTE: The value must be inspectable by `callPackage`. It seems that when functions are exposed via module
          configurations, they do not preserve functionArgs, and so callPackage will fail because it cannot supply
          arguments by default.
        '';
        default = _: {};
        type = types.oneOf [types.path (types.functionTo types.attrs)];
      };
      indexedFixupFn = options.mkOption {
        description = ''
          Attribute set of functions where each key is the `pname` of a redistributable and each value is a
          function to fixup the derivation's attributes after being callPackage'd
          NOTE: The value must be inspectable by `callPackage`. It seems that when functions are exposed via module
          configurations, they do not preserve functionArgs, and so callPackage will fail because it cannot supply
          arguments by default.
        '';
        default = {};
        type = types.oneOf [types.path types.attrs];
      };
    };
    types = options.mkOption {
      description = "A set of generic types.";
      type = types.attrsOf types.optionType;
      default = {
        manifestMeta = types.submodule {
          options = {
            path = options.mkOption {
              description = "Path to the manifest file";
              type = types.path;
            };
            kind = options.mkOption {
              description = "The kind of manifest file";
              type = types.enum [
                "feature"
                "redistrib"
              ];
            };
            version = options.mkOption {
              description = "The manifest version (major.minor)";
              type = config.generic.types.majorMinorVersion;
            };
          };
        };
        manifestPathParser = types.functionTo config.generic.manifests.types.manifestMeta;
        manifestPaths = types.listOf types.path;
        manifestMetas = types.listOf config.generic.manifests.types.manifestMeta;
        manifestMetasToManifests = types.functionTo config.generic.manifests.types.manifests;
        manifests = types.attrsOf (
          types.submodule {
            options = {
              feature = import ./feature/manifest.nix { inherit lib config; };
              redistrib = import ./redistrib/manifest.nix { inherit lib; };
            };
          }
        );
      };
    };
  };
}
