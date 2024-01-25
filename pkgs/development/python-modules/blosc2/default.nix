{ lib
, buildPythonPackage
, cmake
, cython_3
, fetchFromGitHub
, msgpack
, ndindex
, ninja
, numpy
, oldest-supported-numpy
, psutil
, py-cpuinfo
, pytestCheckHook
, scikit-build
, setuptools
, torch
, wheel
}:

buildPythonPackage rec {
  pname = "blosc2";
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-72TBZ0EXMz8BeKJxjnG44//ICgdvoZG9gYC4gdq3+nA=";
  };

  nativeBuildInputs = [
    cmake
    cython_3
    ninja
    oldest-supported-numpy
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
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    torch
  ];

  pythonImportsCheck = [
    "blosc2"
  ];

  meta = with lib; {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
