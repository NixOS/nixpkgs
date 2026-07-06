{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  azure-common,
  azure-storage-common,
  isPy3k,
  futures ? null,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-storage-file";
  version = "2.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NVm5x6sTRQxm6oM+uCwoIzvuJPG9jKGap9J/jCPVvFM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-storage-common
  ]
  ++ lib.optional (!isPy3k) futures;

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.storage.file" ];

  meta = {
    description = "Client library for Microsoft Azure Storage services containing the file service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
})
