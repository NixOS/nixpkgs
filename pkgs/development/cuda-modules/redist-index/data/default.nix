{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.utils) mkRedistURL;
  inherit (config.types)
    attrs
    redistName
    sriHash
    version
    ;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) const importJSON;
  inherit (lib.types) nonEmptyListOf nonEmptyStr package;
  inherit (pkgs) fetchurl;
in
{
  imports = [ ./indices ];
  options.data = mapAttrs (const mkOption) {
    manifestHashes = {
      description = "Hashes used to retrieve CUDA manifests";
      type = attrs redistName (attrs version sriHash);
      default = importJSON ./manifest-hashes.json;
    };
    manifests = {
      description = "Packages containing CUDA manifests";
      type = attrs redistName (attrs version package);
      default = mapAttrs (
        redistName:
        mapAttrs (
          version: hash:
          fetchurl {
            pname = "redistrib-${redistName}";
            url = mkRedistURL redistName "redistrib_${version}.json";
            inherit hash version;
          }
        )
      ) config.data.manifestHashes;
    };
    platforms = {
      description = "List of platforms to use in creation of the platform type.";
      type = nonEmptyListOf nonEmptyStr;
      default = [
        "linux-aarch64"
        "linux-ppc64le"
        "linux-sbsa"
        "linux-x86_64"
        "source" # Source-agnostic platform
      ];
    };
    redistNames = {
      description = "List of redistributable names to use in creation of the redistName type.";
      type = nonEmptyListOf nonEmptyStr;
      default = [
        "cublasmp"
        "cuda"
        "cudnn"
        "cudss"
        "cuquantum"
        "cusolvermp"
        "cusparselt"
        "cutensor"
        # "nvidia-driver",  # NOTE: Some of the earlier manifests don't follow our scheme.
        "nvjpeg2000"
        "nvpl"
        "nvtiff"
        "tensorrt" # NOTE: not truly a redist; uses different naming convention
      ];
    };
    redistUrlPrefix = {
      description = "The prefix of the URL for redistributable files";
      default = "https://developer.download.nvidia.com/compute";
      type = nonEmptyStr;
    };
  };
}
