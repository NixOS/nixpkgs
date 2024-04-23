{
  cudaAtLeast,
  cudaOlder,
  cudaPackages,
  lib,
}:
let
  inherit (cudaPackages) cudatoolkit cuda_cudart libcublas;
  inherit (lib.attrsets) getLib;
  inherit (lib.lists) optionals;
  inherit (lib.strings) hasPrefix;
in
finalAttrs: prevAttrs: {
  allowFHSReferences = true;
  buildInputs =
    prevAttrs.buildInputs
    ++ optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ optionals (cudaAtLeast "11.4") (
      [ (getLib libcublas) ]
      # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
      ++ optionals (hasPrefix "1.4" finalAttrs.version) [ (getLib cuda_cudart) ]
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
}
