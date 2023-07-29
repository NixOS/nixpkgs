{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, scikit-build
, cython
, cmake
, ninja
, wheel

# propagates
, msgpack
, ndindex
, numpy
, py-cpuinfo
, rich

# tests
, psutil
, pytestCheckHook
, torch
}:

buildPythonPackage rec {
  pname = "blosc2";
  version = "2.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-nbPMLkTye0/Q05ubE35LssN677sUIQErPTxjAtSuGgI=";
  };

  # 1. We can use numpy directly instead of oldest-supported-numpy.
  # 2. The build doesn't need the ninja or cmake PyPI packages.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'oldest-supported-numpy' 'numpy' \
      --replace '"ninja", ' "" \
      --replace '"cmake", ' ""

    substituteInPlace requirements-runtime.txt \
      --replace "pytest" ""
  '';

  nativeBuildInputs = [
    cmake
    cython
    ninja
    numpy
    scikit-build
    setuptools
    wheel
  ];

  dontUseCmakeConfigure = true;

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

  meta = with lib; {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
