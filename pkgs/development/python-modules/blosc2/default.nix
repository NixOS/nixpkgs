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
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    rev = "refs/tags/v${version}";
    hash = "sha256-yBgnNJU1q+FktIkpQn74LuRP19Ta/fNC60Z8TxzlWPk=";
  };

  postPatch = ''
    substituteInPlace requirements-runtime.txt \
      --replace "pytest" ""
  '';

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
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
