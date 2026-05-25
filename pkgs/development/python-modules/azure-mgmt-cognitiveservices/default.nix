{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
  msrest,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "15.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_cognitiveservices";
    inherit version;
    hash = "sha256-3ydbAI1IkiIuwnQbd6829kZv9IgFkqTFwG155l58JFQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.cognitiveservices" ];

  meta = {
    description = "This is the Microsoft Azure Cognitive Services Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cognitiveservices/azure-mgmt-cognitiveservices";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-cognitiveservices_${version}/sdk/cognitiveservices/azure-mgmt-cognitiveservices/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
