{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  cmake,
  cython,
  ninja,
  pkg-config,
  scikit-build-core,

  # native dependencies
  c-blosc2,

  # dependencies
  msgpack,
  ndindex,
  numexpr,
  numpy,
  platformdirs,
  py-cpuinfo,
  requests,

  # tests
  psutil,
  pytestCheckHook,
  torch,
  runTorchTests ? lib.meta.availableOn stdenv.hostPlatform torch,
}:

buildPythonPackage rec {
  pname = "blosc2";
  version = "3.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    tag = "v${version}";
    hash = "sha256-t2tf8s2WwG4vEQbh8HACMtUjVrwmGby1yKd+IlL39PY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  dontUseCmakeConfigure = true;
  env.CMAKE_ARGS = lib.cmakeBool "USE_SYSTEM_BLOSC2" true;

  build-system = [
    cython
    numpy
    scikit-build-core
  ];

  buildInputs = [ c-blosc2 ];

  dependencies = [
    msgpack
    ndindex
    numexpr
    numpy
    platformdirs
    py-cpuinfo
    requests
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ]
  ++ lib.optionals runTorchTests [ torch ];

  disabledTestMarks = [
    "network"
  ];

  disabledTests = [
    # attempts external network requests
    "test_with_remote"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/Blosc/python-blosc2/issues/551
    "test_expand_dims"
  ];

  disabledTestPaths = [
    # Threads grow without limit
    # https://github.com/Blosc/python-blosc2/issues/556
    "tests/ndarray/test_lazyexpr.py"
    "tests/ndarray/test_lazyexpr_fields.py"
    "tests/ndarray/test_reductions.py"
  ];

  passthru.c-blosc2 = c-blosc2;

  meta = {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ris ];
  };
}
