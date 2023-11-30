# Type aliases
# Release = {
#  version: String
#  hash: String
#  supportedGpuTargets: List String
# }

{ blas
, cmake
, cudaPackages
, cudaSupport ? config.cudaSupport
, fetchurl
, gfortran
, cudaCapabilities ? cudaPackages.cudaFlags.cudaCapabilities
, gpuTargets ? [ ] # Non-CUDA targets, that is HIP
, rocmPackages
, lapack
, lib
, libpthreadstubs
, magmaRelease
, ninja
, config
  # At least one back-end has to be enabled,
  # and we can't default to CUDA since it's unfree
, rocmSupport ? !cudaSupport
, static ? stdenv.hostPlatform.isStatic
, stdenv
, symlinkJoin
}:


let
  inherit (lib) lists strings trivial;
  inherit (cudaPackages) backendStdenv cudaFlags cudaVersion;
  inherit (magmaRelease) version hash supportedGpuTargets;

  # NOTE: The lists.subtractLists function is perhaps a bit unintuitive. It subtracts the elements
  #   of the first list *from* the second list. That means:
  #   lists.subtractLists a b = b - a

  # For ROCm
  # NOTE: The hip.gpuTargets are prefixed with "gfx" instead of "sm" like cudaFlags.realArches.
  #   For some reason, Magma's CMakeLists.txt file does not handle the "gfx" prefix, so we must
  #   remove it.
  rocmArches = lists.map (x: strings.removePrefix "gfx" x) rocmPackages.clr.gpuTargets;
  supportedRocmArches = lists.intersectLists rocmArches supportedGpuTargets;
  unsupportedRocmArches = lists.subtractLists supportedRocmArches rocmArches;

  supportedCustomGpuTargets = lists.intersectLists gpuTargets supportedGpuTargets;
  unsupportedCustomGpuTargets = lists.subtractLists supportedCustomGpuTargets gpuTargets;

  # Use trivial.warnIf to print a warning if any unsupported GPU targets are specified.
  gpuArchWarner = supported: unsupported:
    trivial.throwIf (supported == [ ])
      (
        "No supported GPU targets specified. Requested GPU targets: "
        + strings.concatStringsSep ", " unsupported
      )
      supported;

  gpuTargetString = strings.concatStringsSep "," (
    if gpuTargets != [ ] then
    # If gpuTargets is specified, it always takes priority.
      gpuArchWarner supportedCustomGpuTargets unsupportedCustomGpuTargets
    else if rocmSupport then
      gpuArchWarner supportedRocmArches unsupportedRocmArches
    else if cudaSupport then
      [ ] # It's important we pass explicit -DGPU_TARGET to reset magma's defaults
    else
      throw "No GPU targets specified"
  );

  # E.g. [ "80" "86" "90" ]
  cudaArchitectures = (builtins.map cudaFlags.dropDot cudaCapabilities);

  cudaArchitecturesString = strings.concatStringsSep ";" cudaArchitectures;
  minArch =
    let
      minArch' = builtins.head (builtins.sort strings.versionOlder cudaArchitectures);
    in
    # "75" -> "750"  Cf. https://bitbucket.org/icl/magma/src/f4ec79e2c13a2347eff8a77a3be6f83bc2daec20/CMakeLists.txt#lines-273
    "${minArch'}0";

in

assert (builtins.match "[^[:space:]]*" gpuTargetString) != null;

stdenv.mkDerivation {
  pname = "magma";
  inherit version;

  src = fetchurl {
    name = "magma-${version}.tar.gz";
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    cmake
    ninja
    gfortran
  ] ++ lists.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    libpthreadstubs
    lapack
    blas
  ] ++ lists.optionals cudaSupport (with cudaPackages; [
    cuda_cudart.dev # cuda_runtime.h
    cuda_cudart.lib # cudart
    cuda_cudart.static # cudart_static
    libcublas.dev # cublas_v2.h
    libcublas.lib # cublas
    libcusparse.dev # cusparse.h
    libcusparse.lib # cusparse
  ] ++ lists.optionals (strings.versionOlder cudaVersion "11.8") [
    cuda_nvprof.dev # <cuda_profiler_api.h>
  ] ++ lists.optionals (strings.versionAtLeast cudaVersion "11.8") [
    cuda_profiler_api.dev # <cuda_profiler_api.h>
  ] ++ lists.optionals (strings.versionAtLeast cudaVersion "12.0") [
    cuda_cccl.dev # <nv/target>
  ]) ++ lists.optionals rocmSupport [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.hipsparse
    rocmPackages.llvm.openmp
  ];

  cmakeFlags = [
    "-DGPU_TARGET=${gpuTargetString}"
    (lib.cmakeBool "MAGMA_ENABLE_CUDA" cudaSupport)
    (lib.cmakeBool "MAGMA_ENABLE_HIP" rocmSupport)
  ] ++ lists.optionals static [
    "-DBUILD_SHARED_LIBS=OFF"
  ] ++ lists.optionals cudaSupport [
    "-DCMAKE_CUDA_ARCHITECTURES=${cudaArchitecturesString}"
    "-DMIN_ARCH=${minArch}" # Disarms magma's asserts
    "-DCMAKE_C_COMPILER=${backendStdenv.cc}/bin/cc"
    "-DCMAKE_CXX_COMPILER=${backendStdenv.cc}/bin/c++"
  ] ++ lists.optionals rocmSupport [
    "-DCMAKE_C_COMPILER=${rocmPackages.clr}/bin/hipcc"
    "-DCMAKE_CXX_COMPILER=${rocmPackages.clr}/bin/hipcc"
  ];

  buildFlags = [
    "magma"
    "magma_sparse"
  ];

  doCheck = false;

  passthru = {
    inherit cudaPackages cudaSupport rocmSupport gpuTargets;
  };

  meta = with lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ connorbaker ];

    # Cf. https://bitbucket.org/icl/magma/src/fcfe5aa61c1a4c664b36a73ebabbdbab82765e9f/CMakeLists.txt#lines-20
    broken =
      !(cudaSupport || rocmSupport) # At least one back-end enabled
      || (cudaSupport && rocmSupport) # Mutually exclusive
      || (cudaSupport && strings.versionOlder cudaVersion "9");
  };
}
