{ lib
, azure-common
, azure-core
, azure-storage-common
, buildPythonPackage
, cryptography
, fetchPypi
, isodate
, msrest
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
  version = "12.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-hg1NgphaS/x9MnHnEnWvMw9U8zCnVDVUNae6dJzN6Zc=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-storage-common
    cryptography
    isodate
    msrest
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-storage-blob_${version}/sdk/storage/azure-storage-blob/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai maxwilson ];
  };
}
