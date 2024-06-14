{
  cmake,
  cudaPackages,
  lib,
  cuda_cudart ? null,
  cuda_nvcc ? null,
  utils,
}:
prevAttrs:
let
  inherit (cudaPackages.utils) mkVersionedPackageName;
  inherit (lib.versions) major;
  desiredCudnnName = mkVersionedPackageName {
    packageName = "cudnn";
    redistName = "cudnn";
    inherit (prevAttrs) version;
  };
  desiredCudnn = cudaPackages.${desiredCudnnName} or null;
  cudnnSamplesMajorVersion = major prevAttrs.version;
in
{
  allowFHSReferences = true;

  # Sources are nested in a directory with the same name as the package
  setSourceRoot = "sourceRoot=$(echo */src/cudnn_samples_v${cudnnSamplesMajorVersion}/)";

  brokenConditions = prevAttrs.brokenConditions // {
    "FreeImage is required as a subdirectory and @connorbaker has not yet patched the build to find it" =
      true;
  };

  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions {
      inherit cuda_cudart cuda_nvcc;
      ${desiredCudnnName} = desiredCudnn;
    };

  nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [
    cmake
    cuda_nvcc
  ];
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    cuda_cudart.dev
    cuda_cudart.lib
    cuda_cudart.static
    desiredCudnn.dev
    desiredCudnn.lib
  ];
}
