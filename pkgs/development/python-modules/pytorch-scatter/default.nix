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

  pybind11,
  torch,

  cudaPackages ? { },
}:

let
  inherit (torch) cudaCapabilities cudaSupport;

  cudaLibs = [
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    cudaPackages.libcusparse
    cudaPackages.libcublas
    cudaPackages.libcusolver
  ];

  cudaIncludes = lib.concatMapStringsSep " " (l: "-I${lib.getInclude l}/include") cudaLibs;
  cudaLibDirs = lib.concatMapStringsSep " " (l: "-L${lib.getLib l}/lib") cudaLibs;
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
    export NVCC_FLAGS="${cudaIncludes} ${cudaLibDirs}"
    export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
    export CUDA_VERSION=${cudaPackages.cudaMajorMinorVersion}
    export CC=${cudaPackages.backendStdenv.cc}/bin/cc
    export CXX=${cudaPackages.backendStdenv.cc}/bin/c++
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    packaging
    torch
    wheel
    which
  ]
  ++ lib.optionals cudaSupport (
    [
      autoAddDriverRunpath
    ]
    ++ cudaLibs
  );

  buildInputs = [
    pybind11
  ]
  ++ lib.optionals cudaSupport cudaLibs;

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
