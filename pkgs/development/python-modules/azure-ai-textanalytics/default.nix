{
  lib,
  azure-core,
  azure-common,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-ai-textanalytics";
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4f7d067d5bb08422599ca6175510d39b0911c711301647e5f18e904a5027bf58";
  };


  propagatedBuildInputs = [
    azure-core
    azure-common
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.ai" ];

  pythonImportsCheck = [ "azure.ai.textanalytics" ];

  meta = with lib; {
    description = "Microsoft Azure Text Analytics Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/textanalytics/azure-ai-textanalytics";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-ai-textanalytics_${version}/sdk/textanalytics/azure-ai-textanalytics/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
       mahalel
    ];
  };
}
