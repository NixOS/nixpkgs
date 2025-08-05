{
  cuda_cudart,
  lib,
  libcublas,
}:
finalAttrs: prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [ (lib.getLib libcublas) ]
    # For some reason, the 1.4.x release of cusparselt requires the cudart library.
    ++ lib.optionals (lib.hasPrefix "1.4" finalAttrs.version) [ (lib.getLib cuda_cudart) ];
  meta = prevAttrs.meta or { } // {
    description = "cuSPARSELt: A High-Performance CUDA Library for Sparse Matrix-Matrix Multiplication";
    homepage = "https://developer.nvidia.com/cusparselt-downloads";
    maintainers = prevAttrs.meta.maintainers or [ ] ++ [ lib.maintainers.sepiabrown ];
    teams = prevAttrs.meta.teams or [ ];
    license = lib.licenses.unfreeRedistributable // {
      shortName = "cuSPARSELt EULA";
      fullName = "cuSPARSELt SUPPLEMENT TO SOFTWARE LICENSE AGREEMENT FOR NVIDIA SOFTWARE DEVELOPMENT KITS";
      url = "https://docs.nvidia.com/cuda/cusparselt/license.html";
    };
  };
}
