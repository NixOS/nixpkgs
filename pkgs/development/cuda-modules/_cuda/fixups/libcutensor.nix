{
  cuda_cudart ? null,
  cudaAtLeast,
  cudaOlder,
  cudatoolkit,
  lib,
  libcublas ? null,
}:
finalAttrs: prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") (
      [ (libcublas.lib or null) ]
      # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
      ++ lib.optionals (lib.hasPrefix "1.4" finalAttrs.version) [ (cuda_cudart.lib or null) ]
    );
  meta = prevAttrs.meta or { } // {
    description = "cuTENSOR: A High-Performance CUDA Library For Tensor Primitives";
    homepage = "https://developer.nvidia.com/cutensor";
    # TODO(@connorbaker): Temporary workaround to avoid changing the derivation hash since introducing more
    # brokenConditions would change the derivation as they're top-level and __structuredAttrs is set.
    broken =
      prevAttrs.meta.broken or false
      || (
        cudaAtLeast "11.4"
        && (libcublas == null || (lib.hasPrefix "1.4" finalAttrs.version && cuda_cudart == null))
      );
    maintainers = prevAttrs.meta.maintainers or [ ] ++ [ lib.maintainers.obsidian-systems-maintenance ];
    teams = prevAttrs.meta.teams;
    license = lib.licenses.unfreeRedistributable // {
      shortName = "cuTENSOR EULA";
      fullName = "cuTENSOR SUPPLEMENT TO SOFTWARE LICENSE AGREEMENT FOR NVIDIA SOFTWARE DEVELOPMENT KITS";
      url = "https://docs.nvidia.com/cuda/cutensor/license.html";
    };
  };
}
