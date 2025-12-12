{ buildRedist, nvpl_blas }:
buildRedist {
  redistName = "cuda";
  pname = "nvpl_lapack";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  buildInputs = [ nvpl_blas ];

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides standard Fortran 90 LAPACK and LAPACKE APIs";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/lapack/release_notes.html";
  };
}
