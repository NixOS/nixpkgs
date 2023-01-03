{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-core
, azure-mgmt-common
, msrest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource";
  version = "22.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-/rXZeeGLUvLP0CO0oKM+VKb3bMaiUtyM117OLGMpjpQ=";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
    msrest
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [
    "azure.mgmt"
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson jonringer ];
  };
}
