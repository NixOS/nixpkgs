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
  version = "2.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kge7BAlBF4L+oibeXIF+tuSNsG1kMjl3WB5PME+RECk=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
