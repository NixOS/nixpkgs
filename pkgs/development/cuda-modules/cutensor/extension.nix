# Support matrix can be found at
# https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-880/support-matrix/index.html
#
# TODO(@connorbaker):
# This is a very similar strategy to CUDA/CUDNN:
#
# - Get all versions supported by the current release of CUDA
# - Build all of them
# - Make the newest the default
#
# Unique twists:
#
# - Instead of providing different releases for each version of CUDA, CuTensor has multiple subdirectories in `lib`
#   -- one for each version of CUDA.
{
  cudaVersion,
  flags,
  lib,
  mkVersionedPackageName,
  stdenv,
}:
let
  inherit (lib)
    attrsets
    lists
    modules
    versions
    strings
    trivial
    ;

  inherit (stdenv) hostPlatform;

  redistName = "cutensor";
  pname = "libcutensor";

  cutensorVersions = [
    "1.3.3"
    "1.4.0"
    "1.5.0"
    "1.6.2"
    "1.7.0"
    "2.0.2"
  ];

  # Manifests :: { redistrib, feature }

  # Each release of cutensor gets mapped to an evaluated module for that release.
  # From there, we can get the min/max CUDA versions supported by that release.
  # listOfManifests :: List Manifests
  listOfManifests =
    let
      configEvaluator =
        fullCutensorVersion:
        modules.evalModules {
          modules = [
            ../modules
            # We need to nest the manifests in a config.cutensor.manifests attribute so the
            # module system can evaluate them.
            {
              cutensor.manifests = {
                redistrib = trivial.importJSON (./manifests + "/redistrib_${fullCutensorVersion}.json");
                feature = trivial.importJSON (./manifests + "/feature_${fullCutensorVersion}.json");
              };
            }
          ];
        };
      # Un-nest the manifests attribute set.
      releaseGrabber = evaluatedModules: evaluatedModules.config.cutensor.manifests;
    in
    lists.map (trivial.flip trivial.pipe [
      configEvaluator
      releaseGrabber
    ]) cutensorVersions;

  # Our cudaVersion tells us which version of CUDA we're building against.
  # The subdirectories in lib/ tell us which versions of CUDA are supported.
  # Typically the names will look like this:
  #
  # - 10.2
  # - 11
  # - 11.0
  # - 12

  # libPath :: String
  libPath =
    let
      cudaMajorMinor = versions.majorMinor cudaVersion;
      cudaMajor = versions.major cudaVersion;
    in
    if cudaMajorMinor == "10.2" then cudaMajorMinor else cudaMajor;

  # A release is supported if it has a libPath that matches our CUDA version for our platform.
  # LibPath are not constant across the same release -- one platform may support fewer
  # CUDA versions than another.
  # redistArch :: String
  redistArch = flags.getRedistArch hostPlatform.system;
  # platformIsSupported :: Manifests -> Boolean
  platformIsSupported =
    { feature, redistrib, ... }:
    (attrsets.attrByPath [
      pname
      redistArch
    ] null feature) != null

    # NOTE: This is an ad hoc hack; manifest schemas do not support version constraints yet
    && !(lib.versionOlder cudaVersion "11.0" && lib.versionAtLeast redistrib.${pname}.version "2.0.2");

  # TODO(@connorbaker): With an auxilliary file keeping track of the CUDA versions each release supports,
  # we could filter out releases that don't support our CUDA version.
  # However, we don't have that currently, so we make a best-effort to try to build TensorRT with whatever
  # libPath corresponds to our CUDA version.
  # supportedManifests :: List Manifests
  supportedManifests = builtins.filter platformIsSupported listOfManifests;

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: RedistribRelease -> String
  computeName = { version, ... }: mkVersionedPackageName redistName version;
in
final: _:
let
  # buildCutensorPackage :: Manifests -> AttrSet Derivation
  buildCutensorPackage =
    { redistrib, feature }:
    let
      drv = final.callPackage ../generic-builders/manifest.nix {
        inherit pname redistName libPath;
        redistribRelease = redistrib.${pname};
        featureRelease = feature.${pname};
      };
      fixedDrv = drv.overrideAttrs (prevAttrs: {
        buildInputs =
          prevAttrs.buildInputs
          ++ lists.optionals (strings.versionOlder cudaVersion "11.4") [ final.cudatoolkit ]
          ++ lists.optionals (strings.versionAtLeast cudaVersion "11.4") (
            [ final.libcublas.lib ]
            # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
            ++ lists.optionals (strings.hasPrefix "1.4" redistrib.${pname}.version) [ final.cuda_cudart.lib ]
          );
        meta = prevAttrs.meta // {
          description = "cuTENSOR: A High-Performance CUDA Library For Tensor Primitives";
          homepage = "https://developer.nvidia.com/cutensor";
          maintainers = prevAttrs.meta.maintainers ++ [ lib.maintainers.obsidian-systems-maintenance ];
          license = lib.licenses.unfreeRedistributable // {
            shortName = "cuTENSOR EULA";
            fullName = "cuTENSOR SUPPLEMENT TO SOFTWARE LICENSE AGREEMENT FOR NVIDIA SOFTWARE DEVELOPMENT KITS";
            url = "https://docs.nvidia.com/cuda/cutensor/license.html";
          };
        };
      });
    in
    attrsets.nameValuePair (computeName redistrib.${pname}) fixedDrv;

  extension =
    let
      nameOfNewest = computeName (lists.last supportedManifests).redistrib.${pname};
      drvs = builtins.listToAttrs (lists.map buildCutensorPackage supportedManifests);
      containsDefault = attrsets.optionalAttrs (drvs != { }) { cutensor = drvs.${nameOfNewest}; };
    in
    drvs // containsDefault;
in
extension
