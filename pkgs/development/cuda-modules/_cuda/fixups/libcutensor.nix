{
  cuda_cudart,
  lib,
  libcublas,
}:
finalAttrs: prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [ (lib.getLib libcublas) ]
    # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
    ++ lib.optionals (lib.hasPrefix "1.4" finalAttrs.version) [ (lib.getLib cuda_cudart) ];
  meta = prevAttrs.meta or { } // {
    description = "cuTENSOR: A High-Performance CUDA Library For Tensor Primitives";
    homepage = "https://developer.nvidia.com/cutensor";
    maintainers = prevAttrs.meta.maintainers or [ ] ++ [ lib.maintainers.obsidian-systems-maintenance ];
    teams = prevAttrs.meta.teams;
    license = lib.licenses.unfreeRedistributable // {
      shortName = "cuTENSOR EULA";
      fullName = "cuTENSOR SUPPLEMENT TO SOFTWARE LICENSE AGREEMENT FOR NVIDIA SOFTWARE DEVELOPMENT KITS";
      url = "https://docs.nvidia.com/cuda/cutensor/license.html";
    };
  };
}
