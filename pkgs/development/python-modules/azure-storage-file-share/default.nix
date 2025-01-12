{
  lib,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-storage-file-share";
  version = "12.20.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_storage_file_share";
    inherit version;
    hash = "sha256-8SD8Z7rgqEwbVNBvqnDfNRvhTROVuaCFNQ6DP300emU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    cryptography
    isodate
    typing-extensions
  ];

  optional-dependencies = {
    aio = [ azure-core ] ++ azure-core.optional-dependencies.aio;
  };

  # Tests require checkout from monorepo
  doCheck = false;

  pythonImportsCheck = [
    "azure.core"
    "azure.storage"
  ];

  meta = with lib; {
    description = "Microsoft Azure File Share Storage Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/storage/azure-storage-file-share";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-storage-file-share_${version}/sdk/storage/azure-storage-file-share/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
