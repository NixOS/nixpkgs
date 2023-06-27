final: prev: let

  inherit (final) callPackage;
  inherit (prev) cudaVersion lib;

  ### Cuda Toolkit Redist

  # Manifest files for redist cudatoolkit. These can be found at
  # https://developer.download.nvidia.com/compute/cuda/redist/
  cudaToolkitRedistManifests = {
    "11.4" = ./manifests/redistrib_11.4.4.json;
    "11.5" = ./manifests/redistrib_11.5.2.json;
    "11.6" = ./manifests/redistrib_11.6.2.json;
    "11.7" = ./manifests/redistrib_11.7.0.json;
    "11.8" = ./manifests/redistrib_11.8.0.json;
    "12.0" = ./manifests/redistrib_12.0.1.json;
    "12.1" = ./manifests/redistrib_12.1.1.json;
  };

  # Function to build a single cudatoolkit redist package
  buildCudaToolkitRedistPackage = callPackage ./build-cuda-redist-package.nix { };

  # Function that builds all cudatoolkit redist packages given a cuda version and manifest file
  buildCudaToolkitRedistPackages = { version, manifest }: let
    attrs = lib.filterAttrs (key: value: key != "release_date") (lib.importJSON manifest);
  in lib.mapAttrs buildCudaToolkitRedistPackage attrs;

  # All cudatoolkit redist packages for the current cuda version
  cudaToolkitRedistPackages = lib.optionalAttrs (lib.hasAttr cudaVersion cudaToolkitRedistManifests)
    (buildCudaToolkitRedistPackages { version = cudaVersion; manifest = cudaToolkitRedistManifests.${cudaVersion}; });

in cudaToolkitRedistPackages
