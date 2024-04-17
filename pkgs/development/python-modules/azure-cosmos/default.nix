{ buildPythonPackage
, lib
, fetchPypi
, six
, requests
}:

buildPythonPackage rec {
  version = "4.6.0";
  format = "setuptools";
  pname = "azure-cosmos";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2uxqwgHGRzsJK2Ku5x44G+62w6jcNhJJgytwSMTwYeI=";
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
