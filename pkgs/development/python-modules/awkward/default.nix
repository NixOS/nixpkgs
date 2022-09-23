{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numba
, numpy
, pytestCheckHook
, pythonOlder
, pyyaml
, rapidjson
, setuptools
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "1.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xjlO0l+xSghtY2IdnYT9wij11CpkWG8hVzGzb94XA0s=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    pyyaml
    rapidjson
  ];

  propagatedBuildInputs = [
    numpy
    setuptools
  ];

  dontUseCmakeConfigure = true;

  checkInputs = [
    pytestCheckHook
    numba
  ];

  disabledTests = [
    # incomatible with numpy 1.23
    "test_numpyarray"
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
