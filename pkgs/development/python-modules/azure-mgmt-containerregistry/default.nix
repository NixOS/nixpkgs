{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-common
, azure-mgmt-core
, msrest
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerregistry";
  version = "10.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VrX9YfYNvlA8+eNqHCp35BAeQZzQKakZs7ZZKwT8oYc=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.containerregistry"
  ];

  meta = with lib; {
    description = "Microsoft Azure Container Registry Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
