{
  buildRedist,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cudnn,
  lib,
}:
buildRedist (finalAttrs: {
  redistName = "cudnn";
  pname = "cudnn_samples";

  outputs = [ "out" ];

  allowFHSReferences = true;

  # Sources are nested in a directory with the same name as the package
  setSourceRoot = "sourceRoot=$(echo */src/cudnn_samples_v${lib.versions.major finalAttrs.version}/)";

  nativeBuildInputs = [
    cmake
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cudart
    cudnn
  ];

  brokenAssertions = [
    {
      message = "FreeImage is required as a subdirectory and @connorbaker has not yet patched the build to find it";
      assertion = false;
    }
  ];
})
