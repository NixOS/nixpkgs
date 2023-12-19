# A function which when callPackage'd returns a function to be given to overrideAttrs.
{
  cudaVersionOlder,
  cudaVersionAtLeast,
  cudaPackages,
  lib,
}:
let
  inherit (lib) lists strings;
in
prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs
    ++ lists.optionals (cudaVersionOlder "11.4") [ cudaPackages.cudatoolkit ]
    ++ lists.optionals (cudaVersionAtLeast "11.4") (
      [ cudaPackages.libcublas.lib ]
      # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
      ++ lists.optionals (strings.hasPrefix "1.4" prevAttrs.version) [ cudaPackages.cuda_cudart.lib ]
    );
  meta = prevAttrs.meta // {
    description = "cuTENSOR: A High-Performance CUDA Library For Tensor Primitives";
    homepage = "https://developer.nvidia.com/cutensor";
    maintainers = prevAttrs.meta.maintainers ++ [ lib.maintainers.obsidian-systems-maintenance ];
    license = lib.licenses.unfreeRedistributable // {
      shortName = "cuTENSOR EULA";
      name = "cuTENSOR SUPPLEMENT TO SOFTWARE LICENSE AGREEMENT FOR NVIDIA SOFTWARE DEVELOPMENT KITS";
      url = "https://docs.nvidia.com/cuda/cutensor/license.html";
    };
  };
}
