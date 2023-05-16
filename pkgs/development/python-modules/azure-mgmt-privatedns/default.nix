<<<<<<< HEAD
{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, msrest
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-privatedns";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MtucYFpKj/ANNON1UdXrBrTsJnq53iph3SJ1ypWj+5g=";
=======
{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-privatedns";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
<<<<<<< HEAD
    isodate
    msrest
  ]  ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
=======
    msrest
    msrestazure
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # no tests included
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.privatedns"
  ];
=======
  pythonImportsCheck = [ "azure.common" "azure.mgmt.privatedns" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Microsoft Azure DNS Private Zones Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
