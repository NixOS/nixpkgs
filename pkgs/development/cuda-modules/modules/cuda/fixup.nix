# A function which when callPackage'd returns a function to be given to overrideAttrs.
{ config, redistName, version, lib, ... }:
prevAttrs:
prevAttrs
// {
  # Add the package-specific license.
  meta = prevAttrs.meta // {
    license = lib.licenses.nvidiaCudaRedist // {
      url =
        let
          default = "${prevAttrs.pname}/LICENSE.txt";
          nullableDesired = config.${redistName}.${version}.redistrib.${prevAttrs.pname}.license_path;
        in
        "https://developer.download.nvidia.com/compute/cuda/redist/"
        + (if nullableDesired != null then nullableDesired else default);
    };
  };
}
