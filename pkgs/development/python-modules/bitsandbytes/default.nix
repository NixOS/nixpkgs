{
  lib,
  torch,
  symlinkJoin,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  scipy,
}:

let
  pname = "bitsandbytes";
  version = "0.46.0";

  inherit (torch) cudaPackages cudaSupport;
  inherit (cudaPackages) cudaMajorMinorVersion;

  cudaMajorMinorVersionString = lib.replaceStrings [ "." ] [ "" ] cudaMajorMinorVersion;

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

  nonCudaAttrs = {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "bitsandbytes-foundation";
      repo = "bitsandbytes";
      tag = version;
      hash = "sha256-q1ltNYO5Ex6F2bfCcsekdsWjzXoal7g4n/LIHVGuj+k=";
    };

    pyproject = true;

    nativeBuildInputs = [ cmake ];

    build-system = [ setuptools ];

    buildInputs = [ ];

    cmakeFlags = [ (lib.cmakeFeature "COMPUTE_BACKEND" "cpu") ];

    preBuild = ''
      make -j $NIX_BUILD_CORES
      cd ..
    '';

    dependencies = [
      scipy
      torch
    ];

    doCheck = false;

    pythonImportsCheck = [ "bitsandbytes" ];

    meta = {
      description = "8-bit CUDA functions for PyTorch";
      homepage = "https://github.com/bitsandbytes-foundation/bitsandbytes";
      changelog = "https://github.com/bitsandbytes-foundation/bitsandbytes/releases/tag/${version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ bcdarwin ];
    };
  };

  cudaAttrs = lib.optionalAttrs cudaSupport {
    postPatch = ''
      substituteInPlace bitsandbytes/cextension.py \
        --replace-fail "if cuda_specs:" "if True:" \
        --replace-fail \
          "cuda_binary_path = get_cuda_bnb_library_path(cuda_specs)" \
          "cuda_binary_path = PACKAGE_DIR / 'libbitsandbytes_cuda${cudaMajorMinorVersionString}.so'"
    '';

    nativeBuildInputs = [ cudaPackages.cuda_nvcc ];

    buildInputs = [ cuda-redist ];

    cmakeFlags = [ (lib.cmakeFeature "COMPUTE_BACKEND" "cuda") ];

    CUDA_HOME = "${cuda-native-redist}";

    NVCC_PREPEND_FLAGS = [
      "-I${cuda-native-redist}/include"
      "-L${cuda-native-redist}/lib"
    ];
  };

in
buildPythonPackage (lib.mergeAttrs cudaAttrs nonCudaAttrs)
