{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  torch,
  torchvision,
  opencv4,
  yapf,
  packaging,
  pillow,
  addict,
  ninja,
  which,
  pybind11,
  onnx,
  onnxruntime,
  scipy,
  pyturbojpeg,
  tifffile,
  lmdb,
  mmengine,
  symlinkJoin,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv cudaVersion;

  cuda-common-redist = with cudaPackages; [
    cuda_cccl # <thrust/*>
    libcublas # cublas_v2.h
    libcusolver # cusolverDn.h
    libcusparse # cusparse.h
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaVersion}";
    paths =
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h
        cuda_nvcc
      ]
      ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist-${cudaVersion}";
    paths = cuda-common-redist;
  };
in
buildPythonPackage rec {
  pname = "mmcv";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmcv";
    rev = "refs/tags/v${version}";
    hash = "sha256-NNF9sLJWV1q6uBE73LUW4UWwYm4TBMTBJjJkFArBmsc=";
  };

  preConfigure =
    ''
      export MMCV_WITH_OPS=1
    ''
    + lib.optionalString cudaSupport ''
      export CC=${backendStdenv.cc}/bin/cc
      export CXX=${backendStdenv.cc}/bin/c++
      export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
      export FORCE_CUDA=1
    '';

  postPatch = ''
    substituteInPlace setup.py --replace "cpu_use = 4" "cpu_use = $NIX_BUILD_CORES"
  '';

  preCheck = ''
    # remove the conflicting source directory
    rm -rf mmcv
  '';

  # test_cnn test_ops really requires gpus to be useful.
  # some of the tests take exceedingly long time.
  # the rest of the tests are disabled due to sandbox env.
  disabledTests = [
    "test_cnn"
    "test_ops"
    "test_fileclient"
    "test_load_model_zoo"
    "test_processing"
    "test_checkpoint"
    "test_hub"
    "test_reader"
  ];

  nativeBuildInputs = [
    ninja
    which
  ] ++ lib.optionals cudaSupport [ cuda-native-redist ];

  buildInputs = [
    pybind11
    torch
  ] ++ lib.optionals cudaSupport [ cuda-redist ];

  nativeCheckInputs = [
    pytestCheckHook
    torchvision
    lmdb
    onnx
    onnxruntime
    scipy
    pyturbojpeg
    tifffile
  ];

  propagatedBuildInputs = [
    mmengine
    torch
    opencv4
    yapf
    packaging
    pillow
    addict
  ];

  pythonImportsCheck = [ "mmcv" ];

  meta = with lib; {
    description = "A Foundational Library for Computer Vision Research";
    homepage = "https://github.com/open-mmlab/mmcv";
    changelog = "https://github.com/open-mmlab/mmcv/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ rxiao ];
  };
}
