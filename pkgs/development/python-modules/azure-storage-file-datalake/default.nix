{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  azure-core,
  azure-storage-blob,
  isodate,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-storage-file-datalake";
  version = "33.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-mgmt-compute_${version}";
    hash = "sha256-Lrr2LMvr7xHOq+bJOUMwO6sY6X+a0MLvdD2P8L166iM=";
  };

  sourceRoot = "${src.name}/sdk/storage/azure-storage-file-datalake";

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    azure-storage-blob
    isodate
    typing-extensions
  ];

  optional-dependencies = {
    aio = [ azure-core ] ++ azure-core.optional-dependencies.aio;
  };

  pythonImportsCheck = [ "azure.storage.filedatalake" ];

  # require devtools_testutils which is a internal package for azure-sdk
  doCheck = false;

  meta = {
    description = "Microsoft Azure File DataLake Storage Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/storage/azure-storage-file-datalake";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
