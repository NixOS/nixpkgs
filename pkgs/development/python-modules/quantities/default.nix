{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fde20115410de21cefa786f3aeae69c1b51bb19ee492190324c1da705e61a81";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # test fails with numpy 1.24
    "test_mul"
  ];

  pythonImportsCheck = [ "quantities" ];

  meta = with lib; {
    description = "Quantities is designed to handle arithmetic and conversions of physical quantities";
    homepage = "https://python-quantities.readthedocs.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
