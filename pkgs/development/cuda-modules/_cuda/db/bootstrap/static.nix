let
  lib = import libPath;
  columnar = import ../columnar.nix;

  inherit (import ../nixpkgs_paths.nix) libPath;

  inherit (columnar) unit listToSetOfStr;
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
        distribution_path = lib.mkDefault null;
        license_path = lib.mkDefault null;
      }
      {
        shortName = {
          "CUDA Toolkit" = unit;
          "${legacy.shortName}" = unit;
          "${generic.shortName}" = unit;
          "MIT" = unit;
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
          "source" = unit;
          "linux-all" = unit;
          "linux-aarch64" = unit;
          "linux-sbsa" = unit;
          "linux-ppc64le" = unit;
          "linux-x86_64" = unit;
          "windows-x86_64" = unit;
        };
        fromNvidia = {
          "source" = listToSetOfStr lib.platforms.all;
          "linux-aarch64"."aarch64-linux" = unit;
          "linux-ppc64le"."powerpc64le-linux" = unit;
          "linux-all" = listToSetOfStr lib.platforms.linux;
          "linux-sbsa"."aarch64-linux" = unit;
          "linux-x86_64"."x86_64-linux" = unit;
          "windows-x86_64" = {
            "x86_64-windows" = unit;
            "x86_64-cygwin" = unit;
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
    pname.tensorrt = unit;
    name.tensorrt = "TensorRT";
    license.tensorrt = lib.licenses.nvidiaProprietary.shortName;
  };
  output = {
    out = unit;
    dev = unit;
    lib = unit;
    bin = unit;
    static = unit;
    doc = unit;
  };
}
