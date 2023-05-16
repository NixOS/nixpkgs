{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-netapp";
<<<<<<< HEAD
  version = "10.1.0";
=======
  version = "10.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-eJiWTOCk2C79Jotku9bKlu3vU6H8004hWrX+h76MjQM=";
=======
    hash = "sha256-9+cXsY8Qr5ds9lYw39duWdcqm6QUTedQbjn8x6zJoyE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.netapp"
  ];

  meta = with lib; {
    description = "Microsoft Azure NetApp Files Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
