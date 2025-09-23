{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "nvpl_blas";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  meta = {
    description = "Part of NVIDIA Performance Libraries that provides standard Fortran 77 BLAS APIs as well as C (CBLAS)";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/blas/release_notes.html";
  };
}
