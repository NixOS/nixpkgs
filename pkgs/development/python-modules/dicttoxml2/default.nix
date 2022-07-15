{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dicttoxml2";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8/Zbv8WxDP5Bn4hgd7hTstmYv7amTlTxhQoKvzYrG/I=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dicttoxml2"
  ];

  meta = with lib;{
    description = "Converts a Python dictionary or other native data type into a valid XML string";
    homepage = "https://pypi.org/project/dicttoxml2/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
