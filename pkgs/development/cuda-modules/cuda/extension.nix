{ cudaMajorMinorVersion, lib }:
let
  inherit (lib) attrsets modules trivial;
  redistName = "cuda";

  # Manifest files for CUDA redistributables (aka redist). These can be found at
  # https://developer.download.nvidia.com/compute/cuda/redist/
  # Maps a cuda version to the specific version of the manifest.
  cudaVersionMap = {
    "12.6" = "12.6.3";
    "12.8" = "12.8.1";
    "12.9" = "12.9.1";
  };

  # Check if the current CUDA version is supported.
  cudaVersionMappingExists = builtins.hasAttr cudaMajorMinorVersion cudaVersionMap;

  # fullCudaVersion : String
  fullCudaVersion = cudaVersionMap.${cudaMajorMinorVersion};

  evaluatedModules = modules.evalModules {
    modules = [
      ../modules
      # We need to nest the manifests in a config.cuda.manifests attribute so the
      # module system can evaluate them.
      {
        cuda.manifests = {
          redistrib = trivial.importJSON (./manifests + "/redistrib_${fullCudaVersion}.json");
          feature = trivial.importJSON (./manifests + "/feature_${fullCudaVersion}.json");
        };
      }
    ];
  };

  # Generally we prefer to do things involving getting attribute names with feature_manifest instead
  # of redistrib_manifest because the feature manifest will have *only* the redist system
  # names as the keys, whereas the redistrib manifest will also have things like version, name, license,
  # and license_path.
  featureManifest = evaluatedModules.config.cuda.manifests.feature;
  redistribManifest = evaluatedModules.config.cuda.manifests.redistrib;

  # Builder function which builds a single redist package for a given platform.
  # buildRedistPackage : callPackage -> PackageName -> Derivation
  buildRedistPackage =
    callPackage: pname:
    callPackage ../generic-builders/manifest.nix {
      inherit pname redistName;
      # We pass the whole release to the builder because it has logic to handle
      # the case we're trying to build on an unsupported platform.
      redistribRelease = redistribManifest.${pname};
      featureRelease = featureManifest.${pname};
    };

  # Build all the redist packages given final and prev.
  redistPackages =
    final: _prev:
    # Wrap the whole thing in an optionalAttrs so we can return an empty set if the CUDA version
    # is not supported.
    # NOTE: We cannot include the call to optionalAttrs *in* the pipe as we would strictly evaluate the
    # attrNames before we check if the CUDA version is supported.
    attrsets.optionalAttrs cudaVersionMappingExists (
      trivial.pipe featureManifest [
        # Get all the package names
        builtins.attrNames
        # Build the redist packages
        (trivial.flip attrsets.genAttrs (buildRedistPackage final.callPackage))
      ]
    );
in
redistPackages
