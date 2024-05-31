{
  lib,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  isodate,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
  version = "12.19.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E+FrpC/FSsLH6Pl2BiFzpcgrnsBZRyjhNKrDcpZaEbA=";
  };

  propagatedBuildInputs = [
    azure-core
    cryptography
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-storage-blob_${version}/sdk/storage/azure-storage-blob/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      cmcdragonkai
      maxwilson
    ];
  };
}
