{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  cython,
  ninja,
  pkg-config,
  scikit-build-core,

  # native dependencies
  c-blosc2,

  # dependencies
  httpx,
  msgpack,
  ndindex,
  numexpr,
  numpy,
  py-cpuinfo,

  # tests
  psutil,
  pytestCheckHook,
  torch,
}:

buildPythonPackage rec {
  pname = "blosc2";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    tag = "v${version}";
    hash = "sha256-em03vwTPURkyZfGdlgpoy8QUzbib9SlcR73vYznlsYA=";
  };

  pythonRelaxDeps = [ "numpy" ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  dontUseCmakeConfigure = true;
  env.CMAKE_ARGS = lib.cmakeBool "USE_SYSTEM_BLOSC2" true;

  build-system = [
    cython
    scikit-build-core
  ];

  buildInputs = [ c-blosc2 ];

  dependencies = [
    httpx
    msgpack
    ndindex
    numexpr
    numpy
    py-cpuinfo
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    torch
  ];

  disabledTests = [
    # RuntimeError: Error while getting the slice
    "test_lazyexpr"
    "test_eval_item"
    # RuntimeError: Error while creating the NDArray
    "test_lossy"
  ];

  passthru.c-blosc2 = c-blosc2;

  meta = with lib; {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
