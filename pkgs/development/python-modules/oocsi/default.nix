{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "oocsi";
  version = "0.4.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AgDBsPoi0aQ6uglc7Zl4gxVmeyDCysoef5vZpxgwE/Q=";
  };

  # Tests are not shipped
  doCheck = false;

  pythonImportsCheck = [ "oocsi" ];

  meta = {
    description = "OOCSI library for Python";
    homepage = "https://github.com/iddi/oocsi-python";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
