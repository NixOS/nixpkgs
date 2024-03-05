{ lib
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerservice";
  version = "29.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RohxeLsQNZM/BvpjEhwaydTFhx8gKuK4a8Svbh47NU8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.containerservice"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerservice/azure-mgmt-containerservice";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerservice_${version}/sdk/containerservice/azure-mgmt-containerservice/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
