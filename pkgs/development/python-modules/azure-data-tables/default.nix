{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-data-tables";
  version = "12.4.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-3V/I3pHi+JCO+kxkyn9jz4OzBoqbpCYpjeO1QTnpZlw=";
  };

  propagatedBuildInputs = [
    azure-core
    msrest
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.data.tables" ];

  meta = with lib; {
    description = "NoSQL data storage service that can be accessed from anywhere";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
