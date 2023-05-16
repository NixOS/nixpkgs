<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-core
, azure-mgmt-core
, msrest
, pythonOlder
=======
{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
<<<<<<< HEAD
  version = "0.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-58k8F/aUBBNJwGBiPZojkSzEXZ3Kd6uEwr0cZbFaM9k=";
=======
    hash = "sha256-XxryuN5HVuY9h6ioSEv9nwzkK6wYLupvFOCJqX82eWE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
<<<<<<< HEAD
    azure-mgmt-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    msrest
  ];

  # zero tests run
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "azure.synapse.artifacts"
  ];
=======
  pythonImportsCheck = [ "azure.synapse.artifacts" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Microsoft Azure Synapse Artifacts Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
