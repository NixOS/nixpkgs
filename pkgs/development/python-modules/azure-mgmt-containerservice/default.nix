{ lib
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerservice";
  version = "28.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tVYFpEUV9v0OOk3CK/oPRA8+fhYl668Gqz6wa/NabNs=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.containerservice"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerservice_${version}/sdk/containerservice/azure-mgmt-containerservice/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
