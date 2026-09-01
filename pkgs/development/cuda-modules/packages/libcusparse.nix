{
  buildRedist,
  cudaAtLeast,
  lib,
  libnvjitlink,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcusparse";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  # Through 12.6.3.3 libnvJitLink is DT_NEEDED and the buildInputs entry below covers it; from
  # 12.7.3.1 it is dlopen'd instead, so it needs a runpath. Unconditional from 12.0 because the
  # entry is a no-op on the releases which already resolve it. 12.7.x asks for the unversioned
  # soname, so the providing output must carry the .so symlink. Gated like the buildInputs entry:
  # libnvjitlink does not exist before CUDA 12.0, and libcusparse does not reference it there.
  appendRunpaths = lib.optionals (cudaAtLeast "12.0") [
    "${lib.getLib libnvjitlink}/lib" # libnvJitLink.so, libnvJitLink.so.%s
  ];

  buildInputs =
    # Dependency from 12.0 and on
    lib.optionals (cudaAtLeast "12.0") [ libnvjitlink ];

  meta = {
    description = "GPU-accelerated basic linear algebra subroutines for sparse matrix computations for unstructured sparsity";
    longDescription = ''
      The cuSPARSE APIs provides GPU-accelerated basic linear algebra subroutines for sparse matrix computations for
      unstructured sparsity.
    '';
    homepage = "https://developer.nvidia.com/cusparse";
    changelog = "https://docs.nvidia.com/cuda/cusparse";
  };
}
