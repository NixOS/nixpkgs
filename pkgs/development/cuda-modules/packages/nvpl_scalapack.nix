{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "nvpl_scalapack";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  meta = {
    description = "Provides an optimized implementation of ScaLAPACK for distributed-memory architectures";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/scalapack/release_notes.html";
  };
}
