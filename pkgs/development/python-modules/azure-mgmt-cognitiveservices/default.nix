{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "13.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_cognitiveservices";
    inherit version;
    hash = "sha256-YS5W956CT4HVkM/wwJJTNYraBl1aYWnBOQX8NQZNm0A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.cognitiveservices" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Cognitive Services Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cognitiveservices/azure-mgmt-cognitiveservices";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-cognitiveservices_${version}/sdk/cognitiveservices/azure-mgmt-cognitiveservices/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
