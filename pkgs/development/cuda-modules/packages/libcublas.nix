{
  backendStdenv,
  buildRedist,
  cuda_nvrtc,
  lib,
  manifests,
}:
let
  cudaCublasVersion = manifests.cuda.libcublas.version;
  standaloneVersion = manifests.cublas.libcublas.version;

  # Package sets may select a standalone cuBLAS release, which must be a newer patch release of the cuBLAS shipped with
  # CUDA. Use it when it has a build for the host.
  isStandalone =
    manifests ? cublas
    &&
      lib.assertMsg
        (
          lib.versions.majorMinor standaloneVersion == lib.versions.majorMinor cudaCublasVersion
          && lib.versionOlder cudaCublasVersion standaloneVersion
        )
        "libcublas: standalone cuBLAS ${standaloneVersion} is not a newer patch release of CUDA's cuBLAS ${cudaCublasVersion}; drop or update the cublas pin"
    && manifests.cublas.libcublas ? ${backendStdenv.hostRedistSystem};

  cudaRelease = buildRedist {
    redistName = "cuda";
    pname = "libcublas";
  };
in
buildRedist (finalAttrs: {
  redistName = if isStandalone then "cublas" else "cuda";
  pname = "libcublas";

  # libcublasLt dlopens NVRTC to compile kernels at runtime; absent before 12.8.
  appendRunpaths = lib.optionals (lib.versionAtLeast finalAttrs.version "12.8") [
    "${lib.getLib cuda_nvrtc}/lib" # libnvrtc.so.%s
  ];

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  # Standalone cuBLAS releases lack the stubs and pkg-config file of the CUDA release they patch. Those still apply:
  # the stubs have the same sonames and exports, and the pkg-config file is versioned by CUDA release.
  ${if isStandalone then "postUnpack" else null} = ''
    cp --recursive ${cudaRelease.src}/lib/stubs "$sourceRoot/lib/"
    cp --recursive ${cudaRelease.src}/pkg-config "$sourceRoot/"
    chmod --recursive u+w "$sourceRoot/lib/stubs" "$sourceRoot/pkg-config"
  '';

  meta = {
    description = "CUDA Basic Linear Algebra Subroutine library";
    longDescription = ''
      The cuBLAS library is an implementation of BLAS (Basic Linear Algebra Subprograms) on top of the NVIDIA CUDA runtime.
    '';
    homepage = "https://developer.nvidia.com/cublas";
    license = lib.licenses.nvidiaCudaRedist;
  };
})
