{ buildRedist, libnvjitlink }:
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

  buildInputs = [ libnvjitlink ];

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
