{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-core,
  msrest,
  msrestazure,
  isodate,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-containerregistry";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Ss0ygh0IZVPqvV3f7Lsh+5FbXRPvg3XRWvyyyAvclqM=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    msrest
    msrestazure
    isodate
  ];

  # tests require azure-devtools which are not published (since 2020)
  # https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/containerregistry/azure-containerregistry/dev_requirements.txt
  doCheck = false;

  pythonImportsCheck = [
    "azure.core"
    "azure.containerregistry"
  ];

  meta = {
    description = "Microsoft Azure Container Registry client library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerregistry/azure-containerregistry";
    license = lib.licenses.mit;
    hasNoMaintainersButDependents = true;
  };
})
