{ buildPythonPackage
, lib
, fetchPypi
, six
, requests
}:

buildPythonPackage rec {
  version = "4.5.1";
  pname = "azure-cosmos";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xK2oOBMG7sQTwBvFCneOJk3D9Pr6nWlvnfhDYUjSrqg=";
  };

  propagatedBuildInputs = [ six requests ];

  pythonNamespaces = [ "azure" ];

  # requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
