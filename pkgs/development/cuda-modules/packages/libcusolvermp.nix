{
  _cuda,
  buildRedist,
  callPackage,
  cuda_cudart,
  lib,
  libcusolver,
  nccl,
}:
buildRedist (finalAttrs: {
  redistName = "cusolvermp";
  pname = "libcusolvermp";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  propagatedBuildInputs = [
    libcusolver
    nccl
  ];

  passthru.tests.headers = callPackage ./tests/public-headers.nix {
    package = finalAttrs.finalPackage;
    headers = [ "cusolverMp.h" ];
    libraries = [ "cusolverMp" ];
    symbols = [ "cusolverMpGetVersion" ];
    driverLibraries = [ "${lib.getOutput cuda_cudart.outputStubs cuda_cudart}/lib/stubs/libcuda.so" ];
  };

  autoPatchelfIgnoreMissingDeps = [
    # Needs to be dynamically loaded as it depends on the hardware
    "libcuda.so.1"
  ];

  meta = {
    description = "High-performance, distributed-memory, GPU-accelerated library that provides tools for solving dense linear systems and eigenvalue problems";
    longDescription = ''
      The NVIDIA cuSOLVERMp library is a high-performance, distributed-memory, GPU-accelerated library that provides
      tools for solving dense linear systems and eigenvalue problems.
    '';
    homepage = "https://developer.nvidia.com/cusolver";
  };
})
