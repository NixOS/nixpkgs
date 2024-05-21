{ lib, config, ... }:
let
  inherit (config.generic.types) majorMinorVersion majorMinorPatchBuildVersion;
  inherit (lib) options types;
in
{
  options.generic.releases = options.mkOption {
    description = "A collection of packages targeting different platforms";
    type =
      let
        Package = options.mkOption {
          description = "A package for a specific platform";
          example = {
            version = "8.0.3.4";
            minCudaVersion = "10.2";
            maxCudaVersion = "10.2";
            hash = "sha256-LxcXgwe1OCRfwDsEsNLIkeNsOcx3KuF5Sj+g2dY6WD0=";
          };
          type = types.submodule {
            # TODO(@connorbaker): Figure out how to extend option sets.
            freeformType = types.attrsOf types.anything;
            options = {
              version = options.mkOption {
                description = "The version of the package";
                type = majorMinorPatchBuildVersion;
              };
              minCudaVersion = options.mkOption {
                description = "The minimum CUDA version supported";
                type = majorMinorVersion;
              };
              maxCudaVersion = options.mkOption {
                description = "The maximum CUDA version supported";
                type = majorMinorVersion;
              };
              hash = options.mkOption {
                description = "The hash of the tarball";
                type = types.str;
              };
            };
          };
        };
      in
      types.attrsOf (types.listOf Package.type);
  };
}
