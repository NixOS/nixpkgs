# Type Aliases
#
# ReleaseAttrs : {
#   "relative_path" : String,
#   "sha256" : String,
#   "md5" : String,
#   "size" : String,
# }
#
# NOTE: PackageAttrs must have at least one of the arches.
# PackageAttrs : {
#   "name" : String,
#   "license" : String,
#   "version" : String,
#   "license_path" : None | String,
#   "linux-aarch64" : None | ReleaseAttrs,
#   "linux-ppc64le" : None | ReleaseAttrs,
#   "linux-sbsa" : None | ReleaseAttrs,
#   "linux-x86_64" : None | ReleaseAttrs,
#   "windows-x86_64" : None | ReleaseAttrs,
# }
#
# ReleaseFeaturesAttrs : {
#   "hasBin" : Boolean,
#   "hasDev" : Boolean,
#   "hasDoc" : Boolean,
#   "hasLib" : Boolean,
#   "hasOut" : Boolean,
#   "hasSample" : Boolean,
#   "hasStatic" : Boolean,
#   "rootDirs" : List String,
# }
#
# NOTE: PackageFeatureAttrs must have at least one of the arches.
# PackageFeatureAttrs : {
#   "linux-aarch64" : None | ReleaseFeaturesAttrs,
#   "linux-ppc64le" : None | ReleaseFeaturesAttrs,
#   "linux-sbsa" : None | ReleaseFeaturesAttrs,
#   "linux-x86_64" : None | ReleaseFeaturesAttrs,
#   "windows-x86_64" : None | ReleaseFeaturesAttrs,
# }
#
final: prev:
let
  # NOTE: We use hasAttr throughout instead of the (?) operator because hasAttr does not require
  # us to interpolate our variables into strings (like ${attrName}).
  inherit (builtins) attrNames concatMap hasAttr listToAttrs removeAttrs;
  inherit (final) callPackage;
  inherit (prev) cudaVersion;
  inherit (prev.lib.attrsets) nameValuePair optionalAttrs;
  inherit (prev.lib.lists) optionals;
  inherit (prev.lib.trivial) flip importJSON pipe;

  # Manifest files for CUDA redistributables (aka redist). These can be found at
  # https://developer.download.nvidia.com/compute/cuda/redist/
  # Maps a cuda version to the specific version of the manifest.
  cudaVersionMap = {
    "11.4" = "11.4.4";
    "11.5" = "11.5.2";
    "11.6" = "11.6.2";
    "11.7" = "11.7.0";
    "11.8" = "11.8.0";
    "12.0" = "12.0.1";
    "12.1" = "12.1.1";
    "12.2" = "12.2.0";
  };

  # Check if the current CUDA version is supported.
  cudaVersionMappingExists = hasAttr cudaVersion cudaVersionMap;

  # Maps a cuda version to its manifest files.
  # The manifest itself is from NVIDIA, but the features manifest is generated
  # by us ahead of time and allows us to split pacakges into multiple outputs.
  # Package names (e.g., "cuda_cccl") are mapped to their attributes or features.
  # Since we map each attribute to a package name, we need to make sure to get rid of meta
  # attributes included in the manifest. Currently, these are any of the following:
  # - release_date
  # - release_label
  # - release_product
  redistManifests =
    let
      # Remove meta attributes from the manifest
      # removeAttrs : AttrSet String b -> Attr String b
      removeMetaAttrs = flip removeAttrs [ "release_date" "release_label" "release_product" ];
      # processManifest : Path -> Attr Set (String PackageAttrs)
      processManifest = flip pipe [ importJSON removeMetaAttrs ];
      # fullCudaVersion : String
      fullCudaVersion = cudaVersionMap.${cudaVersion};
    in
    {
      # features : Attr Set (String PackageFeatureAttrs)
      features = processManifest (./manifests + "/redistrib_features_${fullCudaVersion}.json");
      # manifest : Attr Set (String PackageAttrs)
      manifest = processManifest (./manifests + "/redistrib_${fullCudaVersion}.json");
    };

  # Function to build a single redist package
  buildRedistPackage = callPackage ./build-cuda-redist-package.nix { };

  # Function that builds all redist packages given manifests
  buildRedistPackages = { features, manifest }:
    let
      wrapper = pname:
        let
          # Get the redist architectures the package provides distributables for
          packageAttrs = manifest.${pname};

          # Check if supported
          # TODO(@connorbaker): Currently hardcoding x86_64-linux as the only supported platform.
          isSupported = packageAttrs ? linux-x86_64;

          # Build the derivation
          drv = buildRedistPackage {
            inherit pname;
            # TODO(@connorbaker): We currently discard the license attribute.
            inherit (manifest.${pname}) version;
            description = manifest.${pname}.name;
            platforms = [ "x86_64-linux" ];
            releaseAttrs = manifest.${pname}.linux-x86_64;
            releaseFeaturesAttrs = features.${pname}.linux-x86_64;
          };

          # Wrap in an optional so we can filter out the empty lists created by unsupported
          # packages with concatMap.
          wrapped = optionals isSupported [ (nameValuePair pname drv) ];
        in
        wrapped;

      # concatMap provides us an easy way to filter out packages for unsupported platforms.
      # We wrap the buildRedistPackage call in a list to prevent errors when the package is not
      # supported (by returning an empty list).
      redistPackages = listToAttrs (concatMap wrapper (attrNames manifest));
    in
    redistPackages;

  # All redistributable packages for the current CUDA version
  redistPackages = optionalAttrs cudaVersionMappingExists (buildRedistPackages redistManifests);
in
redistPackages
