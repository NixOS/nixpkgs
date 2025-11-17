{ buildRedist, nvpl_blas }:
buildRedist {
  redistName = "cuda";
  pname = "nvpl_tensor";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  buildInputs = [ nvpl_blas ];

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides tensor primitives";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/tensor/release_notes.html";
  };
}
