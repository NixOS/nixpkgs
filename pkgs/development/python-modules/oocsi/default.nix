{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "oocsi";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AgDBsPoi0aQ6uglc7Zl4gxVmeyDCysoef5vZpxgwE/Q=";
  };

  # Tests are not shipped
  doCheck = false;

  pythonImportsCheck = [
    "oocsi"
  ];

  meta = with lib; {
    description = "OOCSI library for Python";
    homepage = "https://github.com/iddi/oocsi-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
