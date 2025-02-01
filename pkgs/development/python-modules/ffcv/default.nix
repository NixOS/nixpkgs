{
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  lib,
  libjpeg,
  numba,
  opencv4,
  pandas,
  pkg-config,
  pytorch-pfn-extras,
  terminaltables,
  tqdm,
  pytestCheckHook,
  assertpy,
  psutil,
  torchvision,
  webdataset,
  stdenv,
}:

buildPythonPackage rec {
  pname = "ffcv";
  version = "1.0.0";
  pyproject = true;

  # version 1.0.0 uses distutils which was removed in Python 3.12
  disabled = pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "libffcv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-L2mwGFivq/gtAw+1D6U2jbW6VxYgetHX7OUrjwyybqE=";
  };

  # See https://github.com/libffcv/ffcv/issues/159.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'assertpy'," "" \
      --replace-fail "'fastargs'," "" \
      --replace-fail "'opencv-python'," "" \
      --replace-fail "'psutil'," "" \
  '';

  build-system = [ setuptools ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libjpeg ];
  propagatedBuildInputs = [
    opencv4
    numba
    pandas
    pytorch-pfn-extras
    terminaltables
    tqdm
  ];

  pythonImportsCheck = [ "ffcv" ];

  # C/C++ python modules are only in the installed output and not in the build
  # directory. Since tests are run from the build directory python prefers to
  # import the local module first which does not contain the C/C++ python
  # modules and results in an import error. By changing the directory to
  # 'tests' the build directory is no long available and python will import
  # from the installed output in the nix store which does contain the C/C++
  # python modules.
  preCheck = ''
    cd tests
  '';

  nativeCheckInputs = [
    assertpy
    psutil
    pytestCheckHook
    torchvision
    webdataset
  ];

  disabledTestPaths = [
    # Tests require network access and do not work in the sandbox
    "test_augmentations.py"
    # Occasionally causes the testing phase to hang
    "test_basic_pipeline.py"
  ];

  disabledTests = [
    # Tests require network access and do not work in the sandbox
    "test_cifar_subset"
    # Requires CUDA which is unfree and unfree packages are not built by Hydra
    "test_cuda"
    "test_gpu_normalization"
    # torch.multiprocessing.spawn.ProcessRaisedException
    "test_traversal_sequential_2"
    "test_traversal_sequential_3"
    "test_traversal_sequential_4"
    "test_traversal_random_2"
    "test_traversal_random_3"
    "test_traversal_random_4"
    "test_traversal_sequential_distributed_with_indices"
    "test_traversal_random_distributed_with_indices"
  ];

  meta = {
    description = "FFCV: Fast Forward Computer Vision";
    homepage = "https://ffcv.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      samuela
      djacu
    ];
    # OSError: dlopen(libc.so.6, 0x0006): tried: '/usr/lib/libc.so.6' (no such file, not in dyld cache),
    # 'libc.so.6' (no such file), '/usr/local/lib/libc.so.6' (no such file), '/usr/lib/libc.so.6' (no such file, not in dyld cache)
    broken = stdenv.isDarwin;
  };
}
