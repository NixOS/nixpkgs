{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, awkward-cpp
, hatch-fancy-pypi-readme
, hatchling
, numba
, numpy
, packaging
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "2.2.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v06mYdoP/WfIfz6x6+MJvS4YOsTsyWqhCyAykZ1d5v4=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    awkward-cpp
    numpy
    packaging
  ]  ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
    numba
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
