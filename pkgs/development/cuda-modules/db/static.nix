let
  columnar = import ./columnar.nix;
  lib = import ../../../../lib;

  unit = 1;
  listToSetOfStr = lib.flip lib.genAttrs (lib.const unit);
in
{
  license =
    let
      redist = lib.licenses.nvidiaCudaRedist;
      legacy = lib.licenses.nvidiaCuda;
      generic = lib.licenses.nvidiaProprietary;
    in
    columnar.defaults "shortName"
      {
        compiled = lib.licenses.unfree;
        distribution_path = null;
        license_path = null;
      }
      {
        shortName = {
          "CUDA Toolkit" = 1;
          "${legacy.shortName}" = 1;
          "${generic.shortName}" = 1;
          "MIT" = 1;
        };
        compiled = {
          "CUDA Toolkit" = redist;
          "${legacy.shortName}" = legacy;
          "${generic.shortName}" = generic;
          "MIT" = lib.licenses.mit;
        };
        distribution_path = { };
      };
  system =
    columnar.defaults "nvidia"
      {
        fromNvidia = { };
        isSource = false;
        isJetson = false;
        jetsonCompatible = false;
      }
      {
        nvidia = {
          "source" = 1;
          "linux-all" = 1;
          "linux-aarch64" = 1;
          "linux-sbsa" = 1;
          "linux-ppc64le" = 1;
          "linux-x86_64" = 1;
          "windows-x86_64" = 1;
        };
        fromNvidia = {
          "source" = listToSetOfStr lib.platforms.all;
          "linux-aarch64"."aarch64-linux" = 1;
          "linux-ppc64le"."powerpc64le-linux" = 1;
          "linux-all" = listToSetOfStr lib.platforms.linux;
          "linux-sbsa"."aarch64-linux" = 1;
          "linux-x86_64"."x86_64-linux" = 1;
          "windows-x86_64" = {
            "x86_64-windows" = 1;
            "x86_64-cygwin" = 1;
          };
        };
        isSource = {
          "source" = true;
        };
        isJetson = {
          "linux-aarch64" = true;
        };
        jetsonCompatible = {
          "source" = true;
          "linux-aarch64" = true;
        };
      };
  package = {
    # Compensate for missing manifests
    pname.tensorrt = 1;
    license.tensorrt = lib.licenses.nvidiaProprietary.shortName;
  };
  trt_base_url = "https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/{version}/tars/";
}
