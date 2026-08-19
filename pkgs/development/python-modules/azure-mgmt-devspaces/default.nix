{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrestazure,
  azure-common,
  azure-mgmt-nspkg,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-devspaces";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-87TIvgadTe7CP47HX1zJnZh5XXyVtSHXe0EeFFPWcjc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.devspaces" ];

  meta = {
    description = "This is the Microsoft Azure Dev Spaces Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
