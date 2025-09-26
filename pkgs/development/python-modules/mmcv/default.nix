{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ninja,
  which,

  # buildInputs
  pybind11,
  torch,

  # dependencies
  addict,
  mmengine,
  numpy,
  packaging,
  pillow,
  pyyaml,
  yapf,

  # tests
  lmdb,
  onnx,
  onnxruntime,
  pytestCheckHook,
  pyturbojpeg,
  scipy,
  tifffile,
  torchvision,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv;
in
buildPythonPackage rec {
  pname = "mmcv";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = "mmcv";
    tag = "v${version}";
    hash = "sha256-NNF9sLJWV1q6uBE73LUW4UWwYm4TBMTBJjJkFArBmsc=";
  };

  postPatch =
    # Fails in python >= 3.13
    # exec(compile(f.read(), version_file, "exec")) does not populate the locals() namesp
    # In python 3.13, the locals() dictionary in a function does not automatically update with
    # changes made by exec().
    # https://peps.python.org/pep-0558/
    ''
      substituteInPlace setup.py \
        --replace-fail "cpu_use = 4" "cpu_use = $NIX_BUILD_CORES" \
        --replace-fail "return locals()['__version__']" "return '${version}'"
    '';

  nativeBuildInputs = [
    ninja
    which
  ];

  buildInputs = [
    pybind11
    torch
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart # cuda_runtime.h
      cuda_cccl # <thrust/*>
      libcublas # cublas_v2.h
      libcusolver # cusolverDn.h
      libcusparse # cusparse.h
    ]
  );

  dependencies = [
    addict
    mmengine
    numpy
    packaging
    pillow
    pyyaml
    yapf

    # opencv4
    # torch
  ];

  env.CUDA_HOME = lib.optionalString cudaSupport (lib.getDev cudaPackages.cuda_nvcc);

  preConfigure = ''
    export MMCV_WITH_OPS=1
  ''
  + lib.optionalString cudaSupport ''
    export CC=${lib.getExe' backendStdenv.cc "cc"}
    export CXX=${lib.getExe' backendStdenv.cc "c++"}
    export TORCH_CUDA_ARCH_LIST="${lib.concatStringsSep ";" cudaCapabilities}"
    export FORCE_CUDA=1
  '';

  pythonImportsCheck = [ "mmcv" ];

  nativeCheckInputs = [
    lmdb
    onnx
    onnxruntime
    pytestCheckHook
    pyturbojpeg
    scipy
    tifffile
    torchvision
  ];

  # remove the conflicting source directory
  preCheck = ''
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
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # flaky numerical tests (AssertionError)
    "test_ycbcr2rgb"
    "test_ycbcr2bgr"
    "test_tensor2imgs"
  ];

  meta = {
    description = "Foundational Library for Computer Vision Research";
    homepage = "https://github.com/open-mmlab/mmcv";
    changelog = "https://github.com/open-mmlab/mmcv/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ rxiao ];
  };
}
