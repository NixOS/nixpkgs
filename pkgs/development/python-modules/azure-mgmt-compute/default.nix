{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, azure-mgmt-core
<<<<<<< HEAD
, isodate
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-compute";
<<<<<<< HEAD
  version = "30.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "29.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-pWN525DU4kwHi8h0XQ5fdzIp+e8GfNcSwQ+qmIYVp1s=";
=======
    hash = "sha256-LVobrn9dMHyh6FDX6D/tnIOdT2NbEKS40/i8YJisKIg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
<<<<<<< HEAD
    isodate
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.compute"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
