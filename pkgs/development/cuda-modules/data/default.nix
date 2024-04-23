{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) attrNames attrValues mapAttrs;
  inherit (lib.lists)
    concatMap
    filter
    intersectLists
    optionals
    ;
  inherit (lib.options) mkOption;
  inherit (lib.strings) versionOlder;
  inherit (lib.trivial)
    const
    flip
    importJSON
    pipe
    ;
  inherit (lib.types) listOf nonEmptyListOf;
in
{
  config.data.indices = {
    packageInfo = importJSON ../cuda-redist-find-features/data/indices/package-info.json;
    sha256AndRelativePath = importJSON ../cuda-redist-find-features/data/indices/sha256-and-relative-path.json;
  };
  options.data = mapAttrs (const mkOption) {
    cudatoolkitRunfileReleases = {
      description = "List of CUDA runfile releases";
      type = config.types.attrs config.types.versionMajorMinor config.types.cudatoolkitRunfileRelease;
      default = builtins.import ./cudatoolkit-runfile-releases.nix;
    };
    cudaRedistMajorMinorPatchVersions = {
      description = ''
        List of CUDA major.minor.patch versions provided by the redist packages

        Notable: CUDA versions from 11.4.4 are available as redist packages.
      '';
      type = nonEmptyListOf config.types.majorMinorPatchVersion;
      default = attrNames config.data.indices.packageInfo.cuda;
    };
    cudatoolkitMajorMinorPatchVersions = {
      description = ''
        List of CUDA major.minor.patch versions provided by the runfile installer

        Notable: CUDA versions prior to 11.4.4 are not available as redist packages.
      '';
      type = nonEmptyListOf config.types.majorMinorPatchVersion;
      default = pipe config.data.cudatoolkitRunfileReleases [
        attrValues
        (map ({ version, ... }: config.utils.majorMinorPatch version))
        (filter (flip versionOlder "11.4.0"))
      ];
    };
    # These versions typically have at least three components.
    # NOTE: Because the python script which produces the index takes only the latest minor version for each major
    # release, there's no way for us to get collisions in creating the package sets (which are versioned by major and
    # minor releases).
    cudaMajorMinorPatchVersions = {
      description = ''
        List of CUDA major.minor.patch versions available across runfile installers and redist packages
      '';
      type = nonEmptyListOf config.types.majorMinorPatchVersion;
      default =
        config.data.cudatoolkitMajorMinorPatchVersions ++ config.data.cudaRedistMajorMinorPatchVersions;
    };
    gpus = {
      description = "List of supported GPUs";
      type = nonEmptyListOf config.types.gpu;
      default = builtins.import ./gpus.nix;
    };
    # This is used solely for utility functions getNixPlatform and getRedistArch which are needed before the flags
    # attribute set of values and functions is created in the package fixed-point.
    jetsonTargets = {
      description = "List of Jetson targets";
      type = listOf config.types.cudaCapability;
      default =
        let
          allJetsonComputeCapabilities = concatMap (
            gpu: optionals gpu.isJetson [ gpu.computeCapability ]
          ) config.data.gpus;
        in
        intersectLists allJetsonComputeCapabilities (pkgs.config.cudaCapabilities or [ ]);
    };
    nvccCompatibilities = {
      description = "Mapping of CUDA versions to NVCC compatibilities";
      type = config.types.attrs config.types.majorMinorVersion config.types.nvccCompatibility;
      default = builtins.import ./nvcc-compatibilities.nix;
    };
  };
}
