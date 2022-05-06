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
  version = "1.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Bottleneck";
    inherit version;
    hash = "sha256-F2Sn9K1YxVhyPFQoR+s2erC7ttiApOXV7vMKDs5c7Oo=";
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
