{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-imagebuilder";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PzJdaIthJcL6kmgeWxjqQHugMtW+P3wHJEBtcz5sFO8=";
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

  meta = with lib; {
    description = "Microsoft Azure Image Builder Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/compute/azure-mgmt-imagebuilder";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-imagebuilder_${version}/sdk/compute/azure-mgmt-imagebuilder/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
