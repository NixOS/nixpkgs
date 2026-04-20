{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-imagebuilder";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-5sLVc6vvJiIvwUSRgD1MsB+G/GEpLUz3xHKetLrkiRw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.core"
    "azure.mgmt.imagebuilder"
  ];

  meta = {
    description = "Microsoft Azure Image Builder Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/compute/azure-mgmt-imagebuilder";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-imagebuilder_${finalAttrs.version}/sdk/compute/azure-mgmt-imagebuilder/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
