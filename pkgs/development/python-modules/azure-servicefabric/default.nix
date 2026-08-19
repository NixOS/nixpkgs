{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  msrest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-servicefabric";
  version = "8.2.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-9JyHWUR5cIF7my09S5dDl2Xc91ugG2Bmzpa2BQUvuyM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.servicefabric" ];

  meta = {
    description = "This project provides a client library in Python that makes it easy to consume Microsoft Azure Storage services";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
