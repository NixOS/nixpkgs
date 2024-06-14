{
  cudaAtLeast,
  cudaOlder,
  cudaPackages,
  lib,
}:
let
  inherit (lib) lists strings;
  inherit (cudaPackages) cudatoolkit cuda_cudart libcublas;
in
finalAttrs: prevAttrs: {
  allowFHSReferences = true;
  buildInputs =
    prevAttrs.buildInputs
    ++ lists.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lists.optionals (cudaAtLeast "11.4") (
      [ libcublas.lib ]
      # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
      ++ lists.optionals (strings.hasPrefix "1.4" finalAttrs.version) [ cuda_cudart.lib ]
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
