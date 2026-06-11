{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
  isPy3k,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-subscription";
  version = "3.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-TiVbTOm5JDV7uMUAmzyIogFNMgOySV4iVvoCe/hOgA4=";
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
  pythonImportsCheck = [ "azure.mgmt.subscription" ];

  meta = {
    description = "This is the Microsoft Azure Subscription Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
