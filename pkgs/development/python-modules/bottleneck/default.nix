{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bottleneck";
  version = "1.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Bottleneck";
    inherit version;
    hash = "sha256-vBXiVF1CgtbyUpWX3xvW5MXwxEKWs/hCW8g1MFvZQ8k=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "$out/${python.sitePackages}"
  ];

  disabledTests = [
    "test_make_c_files"
  ];

  pythonImportsCheck = [
    "bottleneck"
  ];

  meta = with lib; {
    description = "Fast NumPy array functions";
    homepage = "https://github.com/pydata/bottleneck";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
