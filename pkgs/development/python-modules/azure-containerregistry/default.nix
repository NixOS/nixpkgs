{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-core
, msrest
, msrestazure
, isodate
}:

buildPythonPackage rec {
  pname = "azure-containerregistry";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6IU+fzMIL8HJv4rCrWlcJSuYre6cdBa7BjS9KrIbIRU=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-core
    msrest
    msrestazure
    isodate
  ];

  # tests require azure-devtools which are not published (since 2020)
  # https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/containerregistry/azure-containerregistry/dev_requirements.txt
  doCheck = false;

  pythonImportsCheck = [
    "azure.core"
    "azure.containerregistry"
  ];

  meta = with lib; {
    description = "Microsoft Azure Container Registry client library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerregistry/azure-containerregistry";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
