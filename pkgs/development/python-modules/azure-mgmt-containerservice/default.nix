{
  lib,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  typing-extensions,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerservice";
<<<<<<< HEAD
  version = "40.2.0";
=======
  version = "40.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_containerservice";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-rNVcrpW3aO/rA3fYPeoH1hDENO7AwIngKTX/MfDj4H0=";
=======
    hash = "sha256-iabK9QfTQN9HLcjc/iF8HgmM3Y5xNT24ku/ChDMOL44=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-mgmt-core
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.containerservice" ];

<<<<<<< HEAD
  meta = {
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerservice/azure-mgmt-containerservice";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerservice_${version}/sdk/containerservice/azure-mgmt-containerservice/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
=======
  meta = with lib; {
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerservice/azure-mgmt-containerservice";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerservice_${version}/sdk/containerservice/azure-mgmt-containerservice/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
