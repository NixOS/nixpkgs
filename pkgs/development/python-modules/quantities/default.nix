{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67546963cb2a519b1a4aa43d132ef754360268e5d551b43dd1716903d99812f0";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Tests don't work with current numpy
    # https://github.com/python-quantities/python-quantities/pull/195
    "test_arctan2"
    "test_fix"
  ];

  pythonImportsCheck = [ "quantities" ];

  meta = with lib; {
    description = "Quantities is designed to handle arithmetic and conversions of physical quantities";
    homepage = "https://python-quantities.readthedocs.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
