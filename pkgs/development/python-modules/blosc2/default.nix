{
  lib,
  stdenv,
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
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    tag = "v${version}";
    hash = "sha256-Kimcz4L7Ko4cRj9IaYuLXzmU0+3ERQXOmPXr0E9mOyA=";
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
  ] ++ lib.optionals runTorchTests [ torch ];

  passthru.c-blosc2 = c-blosc2;

  meta = with lib; {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
