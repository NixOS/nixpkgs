{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  azure-common,
  azure-mgmt-core,
  isodate,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-containerinstance";
  version = "10.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-eNQ3rbKFdPRIyDjtXwH5ztN4GWCYBh3rWdn3AxcEwX4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.containerinstance" ];

  meta = {
    description = "This is the Microsoft Azure Container Instance Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
