{
  lib,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
  version = "12.26.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_storage_blob";
    inherit version;
    hash = "sha256-XdfXgkIk994Av+sDJ1NgHJgmVRcwYeJC8Tvm4m141x8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    cryptography
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-storage-blob_${version}/sdk/storage/azure-storage-blob/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cmcdragonkai
      maxwilson
    ];
  };
}
