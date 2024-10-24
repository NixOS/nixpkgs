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
  version = "0.44.1";

  inherit (torch) cudaPackages cudaSupport;
  inherit (cudaPackages) cudaVersion;

  # NOTE: torchvision doesn't use cudnn; torch does!
  #   For this reason it is not included.
  cuda-common-redist = with cudaPackages; [
    cuda_cccl.dev # <thrust/*>
    libcublas.dev # cublas_v2.h
    libcublas.lib
    libcurand
    libcusolver # cusolverDn.h
    libcusparse.dev # cusparse.h
    libcusparse.lib
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaVersion}";
    paths =
      with cudaPackages;
      [
        cuda_cudart.dev # cuda_runtime.h cuda_runtime_api.h
        cuda_cudart.lib
        cuda_cudart.static
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
    hash = "sha256-yvxD5ymMK5p4Xg7Csx/90mPV3yxUC6QUuF/8BKO2p0k=";
  };

  CUDA_HOME = "${cuda-native-redist}";

  build-system = [
    cmake
    setuptools
  ] ++ lib.optionals cudaSupport [ cuda-native-redist ];

  dontUseCmakeConfigure = true;

  buildInputs = lib.optionals cudaSupport [ cuda-redist ];

  preBuild =
    if cudaSupport then
      ''
        export NVCC_APPEND_FLAGS="-I${cuda-native-redist}/include -L${cuda-native-redist}/lib"
        cmake -DCMAKE_CXX_FLAGS="-I${cuda-native-redist}/include" -DCOMPUTE_BACKEND=cuda -S .
        make
      ''
    else
      ''
        cmake -DCOMPUTE_BACKEND=cpu -S .
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
