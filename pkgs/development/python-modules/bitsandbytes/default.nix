{
  lib,
  stdenv,
  symlinkJoin,
  buildPythonPackage,
  fetchFromGitHub,

  cmake,

  # build-system
  scikit-build-core,
  setuptools,

  # dependencies
  torch,
  scipy,

  cudaSupport ? torch.cudaSupport,
  cudaPackages ? torch.cudaPackages,
  rocmSupport ? torch.rocmSupport,
  rocmPackages ? torch.rocmPackages,

  gpuTargets ? [ ],
}:

let
  pname = "bitsandbytes";
  version = "0.47.0";

  brokenConditions = lib.attrsets.filterAttrs (_: cond: cond) {
    "CUDA and ROCm are mutually exclusive" = cudaSupport && rocmSupport;
    "CUDA is not targeting Linux" = cudaSupport && !stdenv.hostPlatform.isLinux;
  };

  inherit (cudaPackages) cudaMajorMinorVersion;
  rocmMajorMinorVersion = lib.versions.majorMinor rocmPackages.rocm-core.version;

  cudaMajorMinorVersionString = lib.replaceStrings [ "." ] [ "" ] cudaMajorMinorVersion;
  rocmMajorMinorVersionString = lib.replaceStrings [ "." ] [ "" ] rocmMajorMinorVersion;

  # Create the gpuTargetString.
  gpuTargetString = lib.strings.concatStringsSep ";" (
    if gpuTargets != [ ] then
      # If gpuTargets is specified, it always takes priority.
      gpuTargets
    else if rocmSupport then
      rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets
    else
      throw "No GPU targets specified"
  );

  # NOTE: torchvision doesn't use cudnn; torch does!
  #   For this reason it is not included.
  cuda-common-redist = with cudaPackages; [
    (lib.getDev cuda_cccl) # <thrust/*>
    (lib.getDev libcublas) # cublas_v2.h
    (lib.getLib libcublas)
    libcurand
    libcusolver # cusolverDn.h
    (lib.getDev libcusparse) # cusparse.h
    (lib.getLib libcusparse) # cusparse.h
    (lib.getDev cuda_cudart) # cuda_runtime.h cuda_runtime_api.h
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaMajorMinorVersion}";
    paths =
      with cudaPackages;
      [
        (lib.getDev cuda_cudart) # cuda_runtime.h cuda_runtime_api.h
        (lib.getLib cuda_cudart)
        (lib.getStatic cuda_cudart)
        cuda_nvcc
      ]
      ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaMajorMinorVersion}";
    paths = cuda-common-redist;
  };

  rocm-redist = symlinkJoin {
    name = "rocm-redist-${rocmMajorMinorVersion}";
    paths = with rocmPackages; [
      # CMake enable_language(hip):
      (lib.getLib clr) # HIP runtime - hip-lang-config.cmake

      # CMake find_package:
      (lib.getLib hipblas) # hipblas-config.cmake
      (lib.getLib hipblas-common) # hipblas-common-config.cmake
      (lib.getLib hiprand) # hiprand-config.cmake
      (lib.getLib rocrand) # rocrand-config.cmake
      (lib.getLib hipsparse) # hipsparse-config.cmake
      (lib.getLib hipsparse) # hipsparse-config.cmake
      (lib.getLib hipblaslt) # hipblaslt-config.cmake (warn)

      # CMake target_link_libraries:
      (lib.getDev hipblaslt) # roc::hipblaslt

      (lib.getDev rocblas) # rocblas/rocblas.h
      (lib.getDev hipcub) # hipcub/hipcub.hpp
      (lib.getDev rocprim) # rocprim/device/config_types.hpp
    ];
  };
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitsandbytes-foundation";
    repo = "bitsandbytes";
    tag = version;
    hash = "sha256-iUAeiNbPa3Q5jJ4lK2G0WvTKuipb0zO1mNe+wcRdnqs=";
  };

  # By default, which library is loaded depends on the result of `torch.cuda.is_available()`.
  # When `cudaSupport` is enabled, bypass this check and load the cuda library unconditionally.
  # Indeed, in this case, only `libbitsandbytes_cuda124.so` is built. `libbitsandbytes_cpu.so` is not.
  # Also, hardcode the path to the previously built library instead of relying on
  # `get_cuda_bnb_library_path(cuda_specs)` which relies on `torch.cuda` too.
  #
  # WARNING: The cuda library is currently named `libbitsandbytes_cudaxxy` for CUDA version `xx.y`
  # and `libbitsandbytes_rocmxxy` for ROCm version `xx.y`
  # This upstream convention could change at some point and thus break the following patch.
  postPatch = (
    let
      prefix = if cudaSupport then "cuda" else "rocm";
      majorMinorVersionString =
        if cudaSupport then cudaMajorMinorVersionString else rocmMajorMinorVersionString;
    in
    lib.optionalString (cudaSupport || rocmSupport) ''
      substituteInPlace bitsandbytes/cextension.py \
        --replace-fail "if cuda_specs:" "if True:" \
        --replace-fail \
          "cuda_binary_path = get_cuda_bnb_library_path(cuda_specs)" \
          "cuda_binary_path = PACKAGE_DIR / 'libbitsandbytes_${prefix}${majorMinorVersionString}.so'"
    ''
  );

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals rocmSupport [
    rocmPackages.hipcc
    rocmPackages.rocminfo
  ];

  build-system = [
    scikit-build-core
    setuptools
  ];

  buildInputs = lib.optional cudaSupport cuda-redist ++ lib.optional rocmSupport rocm-redist;

  cmakeFlags = [
    (lib.cmakeFeature "COMPUTE_BACKEND" (
      if cudaSupport then
        "cuda"
      else if rocmSupport then
        "hip"
      else
        "cpu"
    ))
  ]
  ++ lib.optional rocmSupport (lib.cmakeFeature "AMDGPU_TARGETS" "${gpuTargetString}");
  CUDA_HOME = lib.optionalString cudaSupport "${cuda-native-redist}";
  NVCC_PREPEND_FLAGS = lib.optionals cudaSupport [
    "-I${cuda-native-redist}/include"
    "-L${cuda-native-redist}/lib"
  ];
  ROCM_PATH = lib.optionalString rocmSupport "${rocm-redist}";

  preBuild = ''
    make -j $NIX_BUILD_CORES
    cd .. # leave /build/source/build
  '';

  dependencies = [
    scipy
    torch
  ];

  doCheck = false; # tests require CUDA and also GPU access

  pythonImportsCheck = [ "bitsandbytes" ];

  passthru = {
    inherit
      cudaSupport
      cudaPackages
      rocmSupport
      rocmPackages
      brokenConditions # To help debug when a package is broken due to CUDA support
      ;
  };

  meta = {
    description = "8-bit CUDA functions for PyTorch";
    homepage = "https://github.com/bitsandbytes-foundation/bitsandbytes";
    changelog = "https://github.com/bitsandbytes-foundation/bitsandbytes/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bcdarwin
      jk
    ];
    platforms =
      lib.platforms.linux ++ lib.optionals (!cudaSupport && !rocmSupport) lib.platforms.darwin;
    broken = builtins.any lib.trivial.id (builtins.attrValues brokenConditions);
  };
}
