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
