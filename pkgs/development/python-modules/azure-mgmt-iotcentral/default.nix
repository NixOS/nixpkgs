{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
  isPy3k,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-iotcentral";
  version = "9.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-ZN9z30SabzcX89CWPlhpIk7T5iFsed5XFJO+p8G1LLY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ]
  ++ lib.optionals (!isPy3k) [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.iotcentral" ];

  meta = {
    description = "This is the Microsoft Azure IoTCentral Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
