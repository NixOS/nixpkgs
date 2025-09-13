{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  einops,
  ninja,
  setuptools,
  symlinkJoin,
  torch,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv cudaMajorMinorVersion;

  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v4.1.0";
    hash = "sha256-ZY+6Tg/CC6fqvU764k6QNudYDpY+s8OQklG+1aXQuns=";
  };

  cuda-common-redist = with cudaPackages; [
    (lib.getDev cuda_cccl) # <thrust/*>
    (lib.getDev libcublas) # cublas_v2.h
    (lib.getLib libcublas)
    (lib.getDev libcurand) # curand.h
    (lib.getLib libcurand)
    (lib.getDev libcusolver) # cusolverDn.h
    (lib.getLib libcusolver)
    (lib.getDev libcusparse) # cusparse.h
    (lib.getLib libcusparse)
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaMajorMinorVersion}";
    paths =
      with cudaPackages;
      [
        (lib.getDev cuda_cudart) # cuda_runtime.h cuda_runtime_api.h
        (lib.getLib cuda_cudart)
        cuda_nvcc
      ]
      ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaMajorMinorVersion}";
    paths = cuda-common-redist;
  };

in
buildPythonPackage rec {
  pname = "flash-attention";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    tag = "v${version}";
    hash = "sha256-RrayQOxQzGJMQK5jmMziR59p8CTF8mpEyJsqzouEW1s=";
  };

  postPatch = ''
    rmdir csrc/cutlass
    ln -s ${cutlass} csrc/cutlass
  '';

  preConfigure = ''
    export FLASH_ATTENTION_FORCE_BUILD="TRUE"
    export FLASH_ATTENTION_SKIP_CUDA_BUILD="TRUE"
  ''
  + lib.optionalString cudaSupport ''
    export CC=${backendStdenv.cc}/bin/cc
    export CXX=${backendStdenv.cc}/bin/c++
    export CUDA_HOME=${cuda-native-redist}
    export FLASH_ATTENTION_SKIP_CUDA_BUILD="FALSE"
    export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
  '';

  preBuild = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export NVCC_THREADS="$NIX_BUILD_CORES"
  '';

  build-system = [
    ninja
    setuptools
  ]
  ++ lib.optionals cudaSupport [
    cuda-native-redist
  ];

  buildInputs = lib.optionals cudaSupport [ cuda-redist ];

  dependencies = [
    einops
    torch
  ];

  # Requires NVIDIA driver.
  doCheck = false;

  pythonImportsCheck = [ "flash_attn" ];

  meta = {
    broken = !cudaSupport;
    description = "Official implementation of FlashAttention and FlashAttention-2";
    homepage = "https://github.com/Dao-AILab/flash-attention/";
    changelog = "https://github.com/Dao-AILab/flash-attention/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
