{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lo1AUxj+QR7N2Tdif58zGBMSp5Pr0jmz2nacRDnLS5g=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beartype"
  ];

  meta = with lib; {
    description = "Fast runtime type checking for Python";
    homepage = "https://github.com/beartype/beartype";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
