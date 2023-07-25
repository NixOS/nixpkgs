{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-data-tables";
  version = "12.4.3";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-qLA0vNRyIu36xKwB55BD/TCTOv+nmyOtk3+Y4P+SalI=";
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
