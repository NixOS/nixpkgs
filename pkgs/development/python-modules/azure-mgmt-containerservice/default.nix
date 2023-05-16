{ lib
<<<<<<< HEAD
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
=======
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerservice";
<<<<<<< HEAD
  version = "26.0.0";
=======
  version = "22.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-BpvnSqee5wodtMXPxo/pHCBk8Yy4yPnEdK164d9ILuM=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
=======
    extension = "zip";
    hash = "sha256-GTfFj2XJe01RaHKUTdRm/ZRfNIvsxxmflxTcfQfaY04=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
