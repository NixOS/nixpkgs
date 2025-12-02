{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_profiler_api";

  outputs = [
    "out"
    "dev"
    "include"
  ];

  meta.description = "API for profiling CUDA runtime";
}
