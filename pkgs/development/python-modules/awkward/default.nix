{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, awkward-cpp
, cupy
, hatch-fancy-pypi-readme
, hatchling
, importlib-metadata
, numba
, numpy
, packaging
, setuptools
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "2.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-soMmJ2JXhoR7rmCjtb+5388WfwnDrEbILyMvJqdymro=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    awkward-cpp
    numpy
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.12") [
    importlib-metadata
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    cupy
    pytestCheckHook
    numba
    setuptools
  ];

  disabledTestPaths = [
    "tests-cuda"
  ];

  pythonImportsCheck = [
    "awkward"
  ];

  meta = with lib; {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
