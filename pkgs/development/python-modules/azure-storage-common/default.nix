{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  azure-common,
  cryptography,
  python-dateutil,
  requests,
  isPy3k,
  azure-storage-nspkg,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-storage-common";
  version = "2.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zO3vXGcie8TWZw/9N87Bj7UpobfDpeU+QJbrDPI9xz8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    cryptography
    python-dateutil
    requests
  ]
  ++ lib.optional (!isPy3k) azure-storage-nspkg;

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.storage.common" ];

  meta = {
    description = "Client library for Microsoft Azure Storage services containing common code shared by blob, file and queue";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
})
