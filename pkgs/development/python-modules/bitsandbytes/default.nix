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
  version = "0.43.3";

  inherit (torch) cudaPackages cudaSupport;
  inherit (cudaPackages) cudaVersion;

  # NOTE: torchvision doesn't use cudnn; torch does!
  #   For this reason it is not included.
  cuda-common-redist = with cudaPackages; [
    cuda_cccl # <thrust/*>
    libcublas # cublas_v2.h
    libcurand
    libcusolver # cusolverDn.h
    libcusparse # cusparse.h
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaVersion}";
    paths =
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h cuda_runtime_api.h
        cuda_nvcc
      ]
      ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaVersion}";
    paths = cuda-common-redist;
  };
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TimDettmers";
    repo = "bitsandbytes";
    rev = "refs/tags/${version}";
    hash = "sha256-JOB+WCrLFjjeJJHbsOei8+D5CMuFmyVLnoKRd05tYDU=";
  };

  # CUDA_HOME = "${cuda-native-redist}";

  build-system = [
    cmake
    setuptools
  ] ++ lib.optionals cudaSupport [ cuda-native-redist ];

  dontUseCmakeConfigure = true;

  buildInputs = lib.optionals cudaSupport [ cuda-redist ];

  preBuild =
    let
      backend = if cudaSupport then "cuda" else "cpu";
    in
    ''
      cmake -DCOMPUTE_BACKEND=${backend} -S .
      make
    '';

  dependencies = [
    scipy
    torch
  ];

  doCheck = false; # tests require CUDA and also GPU access

  pythonImportsCheck = [ "bitsandbytes" ];

  meta = {
    description = "8-bit CUDA functions for PyTorch";
    homepage = "https://github.com/TimDettmers/bitsandbytes";
    changelog = "https://github.com/TimDettmers/bitsandbytes/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
