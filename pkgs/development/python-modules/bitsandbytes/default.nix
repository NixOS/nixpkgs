{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  stdenv,
  cmake,
  numpy,
  scipy,
  setuptools,
  torch,
  wheel,
}:

let
  pname = "bitsandbytes";
  version = "0.43.1";

  inherit (torch) cudaSupport;
  inherit (torch.cudaPackages)
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudaFlags
    libcublas
    libcurand
    libcusolver
    libcusparse
    ;
  inherit (lib.lists) optionals;
  inherit (lib.strings) cmakeFeature;
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TimDettmers";
    repo = "bitsandbytes";
    rev = "refs/tags/${version}";
    hash = "sha256-GFbFKPdV96DXPA+PZO4h0zdBclN670fb0PGv4QPHWHU=";
  };

  cmakeFlags =
    [
      (cmakeFeature "COMPUTE_BACKEND" (
        if cudaSupport then
          "cuda"
        else if stdenv.isDarwin then
          "mps"
        else
          "cpu"
      ))
    ]
    ++ optionals cudaSupport [
      (cmakeFeature "COMPUTE_CAPABILITY" cudaFlags.cmakeCudaArchitecturesString)
    ];

  # Ensure the generated CMake files are executed in a build before the Python hooks take over packaging.
  preBuild = ''
    make -j $NIX_BUILD_CORES
  '';

  dontUseCmakeBuildDir = true;

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [ cmake ] ++ optionals cudaSupport [ cuda_nvcc ];

  buildInputs = optionals cudaSupport [
    cuda_cudart # cuda_runtime.h
    cuda_cccl # <thrust/*>
    libcublas # cublas_v2.h
    libcurand
    libcusolver # cusolverDn.h
    libcusparse # cusparse.h
  ];

  dependencies = [
    numpy
    torch
  ];

  nativeCheckInputs = [ scipy ];

  doCheck = false; # tests require CUDA and also GPU access

  # Don't check for Python import when building with CUDA support, as it requires access to the GPU:
  # https://github.com/TimDettmers/bitsandbytes/blob/4a6fb352cfb90b17820391f0db18aeda98774f0a/bitsandbytes/cuda_specs.py#L33-L35
  pythonImportsCheck = optionals (!cudaSupport) [ "bitsandbytes" ];

  meta = with lib; {
    description = "8-bit CUDA functions for PyTorch";
    homepage = "https://github.com/TimDettmers/bitsandbytes";
    changelog = "https://github.com/TimDettmers/bitsandbytes/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
