# Support matrix can be found at
# https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-880/support-matrix/index.html
{
  cudaLib,
  lib,
  redistSystem,
}:
let
  inherit (lib)
    attrsets
    lists
    modules
    trivial
    ;

  redistName = "cusparselt";
  pname = "libcusparse_lt";

  cusparseltVersions = [
    "0.7.1"
  ];

  # Manifests :: { redistrib, feature }

  # Each release of cusparselt gets mapped to an evaluated module for that release.
  # From there, we can get the min/max CUDA versions supported by that release.
  # listOfManifests :: List Manifests
  listOfManifests =
    let
      configEvaluator =
        fullCusparseltVersion:
        modules.evalModules {
          modules = [
            ../modules
            # We need to nest the manifests in a config.cusparselt.manifests attribute so the
            # module system can evaluate them.
            {
              cusparselt.manifests = {
                redistrib = trivial.importJSON (./manifests + "/redistrib_${fullCusparseltVersion}.json");
                feature = trivial.importJSON (./manifests + "/feature_${fullCusparseltVersion}.json");
              };
            }
          ];
        };
      # Un-nest the manifests attribute set.
      releaseGrabber = evaluatedModules: evaluatedModules.config.cusparselt.manifests;
    in
    lists.map (trivial.flip trivial.pipe [
      configEvaluator
      releaseGrabber
    ]) cusparseltVersions;

  # platformIsSupported :: Manifests -> Boolean
  platformIsSupported =
    { feature, redistrib, ... }:
    (attrsets.attrByPath [
      pname
      redistSystem
    ] null feature) != null;

  # TODO(@connorbaker): With an auxiliary file keeping track of the CUDA versions each release supports,
  # we could filter out releases that don't support our CUDA version.
  # However, we don't have that currently, so we make a best-effort to try to build TensorRT with whatever
  # libPath corresponds to our CUDA version.
  # supportedManifests :: List Manifests
  supportedManifests = builtins.filter platformIsSupported listOfManifests;

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: RedistribRelease -> String
  computeName =
    { version, ... }: cudaLib.mkVersionedName redistName (lib.versions.majorMinor version);
in
final: _:
let
  # buildCusparseltPackage :: Manifests -> AttrSet Derivation
  buildCusparseltPackage =
    { redistrib, feature }:
    let
      drv = final.callPackage ../generic-builders/manifest.nix {
        inherit pname redistName;
        redistribRelease = redistrib.${pname};
        featureRelease = feature.${pname};
      };
    in
    attrsets.nameValuePair (computeName redistrib.${pname}) drv;

  extension =
    let
      nameOfNewest = computeName (lists.last supportedManifests).redistrib.${pname};
      drvs = builtins.listToAttrs (lists.map buildCusparseltPackage supportedManifests);
      containsDefault = attrsets.optionalAttrs (drvs != { }) { cusparselt = drvs.${nameOfNewest}; };
    in
    drvs // containsDefault;
in
extension
