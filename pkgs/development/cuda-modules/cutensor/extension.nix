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
  cudaMajorMinorVersion,
  flags,
  lib,
  mkVersionedPackageName,
  stdenv,
  _cuda,
}:
let
  inherit (lib)
    attrsets
    lists
    modules
    versions
    trivial
    ;

  inherit (stdenv) hostPlatform;

  redistName = "cutensor";
  pname = "libcutensor";

  cutensorVersions = builtins.attrNames _cuda.db.package.version.cutensor;

  # Manifests :: { redistrib, feature }

  # Our cudaMajorMinorVersion tells us which version of CUDA we're building against.
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
      cudaMajorVersion = versions.major cudaMajorMinorVersion;
    in
    if cudaMajorMinorVersion == "10.2" then cudaMajorMinorVersion else cudaMajorVersion;

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: RedistribRelease -> String
  computeName = { version, ... }: mkVersionedPackageName redistName version;
in
final: _:
let
  # buildCutensorPackage :: Manifests -> AttrSet Derivation
  buildCutensorPackage =
    version:
    let
      drv = final.callPackage ../generic-builders/manifest.nix {
        inherit
          pname
          redistName
          libPath
          version
          ;
      };
    in
    attrsets.nameValuePair (computeName { inherit version; }) drv;

  extension =
    let
      drvs = builtins.listToAttrs (lists.map buildCutensorPackage cutensorVersions);
      supportedDrvs = lib.mapAttrs (_name: p: !p.meta.unsupported) drvs;
      newest = lists.last ((builtins.attrValues supportedDrvs) ++ builtins.attrValues drvs);
      containsDefault = attrsets.optionalAttrs (drvs != { }) { cutensor = newest; };
    in
    drvs // containsDefault;
in
extension
