# A function which when callPackage'd returns a function to be given to overrideAttrs.
{
  lib,
  manifests,
  nullableOr,
  ...
}:
prevAttrs:
prevAttrs
// {
  # Add the package-specific license.
  meta = prevAttrs.meta // {
    license = lib.licenses.nvidiaCudaRedist // {
      url =
        "https://developer.download.nvidia.com/compute/cuda/redist/"
        + nullableOr "${prevAttrs.pname}/LICENSE.txt" manifests.redistrib.${prevAttrs.pname}.license_path;
    };
  };
}
