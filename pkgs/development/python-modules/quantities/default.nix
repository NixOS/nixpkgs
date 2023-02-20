{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7+r//AwDZPiRqTJyOc0SSWvMtVzQN6bRv0TecG9yKHc=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
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
