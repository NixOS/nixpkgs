{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  autoAddDriverRunpath,
  which,
  wheel,
  packaging,
  pytestCheckHook,
  setuptools,
  symlinkJoin,

  pybind11,
  torch,

  cudaPackages ? { },
}:

let
  inherit (torch) cudaCapabilities cudaSupport;
  inherit (cudaPackages) backendStdenv cudaVersion;

  cuda-common-redist = with cudaPackages; [
    (lib.getDev cuda_cccl) # <thrust/*>
    (lib.getDev libcublas) # cublas_v2.h
    (lib.getLib libcublas)
    (lib.getDev libcusolver) # cusolverDn.h
    (lib.getLib libcusolver)
    (lib.getDev libcusparse) # cusparse.h
    (lib.getLib libcusparse)
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaVersion}";
    paths =
      with cudaPackages;
      [
        (lib.getDev cuda_cudart) # cuda_runtime.h cuda_runtime_api.h
        (lib.getLib cuda_cudart)
        (lib.getStatic cuda_cudart)
        cuda_nvcc
      ]
      ++ cuda-common-redist;
    postBuild = ''
      ln -s $out/lib/stubs/libcuda.so $out/lib
    '';
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaVersion}";
    paths = cuda-common-redist;
  };

in
buildPythonPackage rec {
  pname = "pytorch_scatter";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_scatter";
    tag = version;
    hash = "sha256-dmJrsWoFsqFlrgfbFHeD5f//qUg0elmksIZG8vXXShc=";
  };

  preConfigure = ''
    export NVCC_THREADS="$NIX_BUILD_CORES"
    export MAX_JOBS="$NIX_BUILD_CORES"
  '';

  preBuild = lib.optionalString cudaSupport ''
    export FORCE_CUDA=1
    export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
    export CUDA_VERSION=${cudaVersion}
    export CC=${backendStdenv.cc}/bin/cc
    export CXX=${backendStdenv.cc}/bin/c++
    export CUDA_HOME=${cuda-native-redist}
  '';

  build-system = [ setuptools ];
  nativeBuildInputs =
    [
      packaging
      torch
      wheel
      which
    ]
    ++ lib.optionals cudaSupport [
      autoAddDriverRunpath
      cuda-native-redist
    ];

  buildInputs =
    [
      pybind11
    ]
    ++ lib.optionals cudaSupport [
      cuda-redist
    ];

  dependencies = [ torch ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Ensure tests import the installed module, not the source subdir
    rm -rf torch_scatter
  '';

  pythonImportsCheck = [ "torch_scatter" ];

  meta = {
    description = "Small extension library of highly optimized sparse update (scatter and segment) operations for use in PyTorch";
    homepage = "https://github.com/rusty1s/pytorch_scatter";
    changelog = "https://github.com/rusty1s/pytorch_scatter/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
