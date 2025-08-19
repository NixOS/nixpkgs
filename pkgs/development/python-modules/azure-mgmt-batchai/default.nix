{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  isodate,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-batchai";
  version = "7.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "azure_mgmt_batchai";
    hash = "sha256-XfAE/QyST8ZVlJR6nP9Pdgh97hfIhFM6G7sLINsn06M=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Batch AI Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-batchai_${version}/sdk/batchai/azure-mgmt-batchai/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
