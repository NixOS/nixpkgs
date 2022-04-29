{ lib
, azure-core
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-cosmos";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-hnGR+llmRGEB98o4NPIwYKhXNdC2YDA8o1OGSUXVcrY=";
  };

  propagatedBuildInputs = [
    azure-core
  ];

  pythonNamespaces = [
    "azure"
  ];

  # Requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
