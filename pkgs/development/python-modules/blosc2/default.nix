{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  cython,
  ninja,
  oldest-supported-numpy,
  pkg-config,
  scikit-build,
  setuptools,
  wheel,

  # c library
  c-blosc2,

  # propagates
  msgpack,
  ndindex,
  numexpr,
  numpy,
  py-cpuinfo,
  rich,

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

  postPatch = ''
    substituteInPlace requirements-runtime.txt \
      --replace "pytest" ""
  '';

  pythonRelaxDeps = [ "numpy" ];

  nativeBuildInputs = [
    cmake
    cython
    ninja
    oldest-supported-numpy
    pkg-config
    scikit-build
    setuptools
    wheel
  ];

  buildInputs = [ c-blosc2 ];

  dontUseCmakeConfigure = true;
  env.CMAKE_ARGS = "-DUSE_SYSTEM_BLOSC2:BOOL=YES";

  propagatedBuildInputs = [
    msgpack
    ndindex
    numexpr
    numpy
    py-cpuinfo
    rich
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    torch
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
