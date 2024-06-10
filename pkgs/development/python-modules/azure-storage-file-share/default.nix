{
  lib,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  isodate,
  msrest,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-storage-file-share";
  version = "12.16.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QS+35sPCj29yKvmBlapZQHqqMjI6+hOkoB9i0Lh3TrM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    cryptography
    isodate
    typing-extensions
  ];

  passthru.optional-dependencies = {
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
