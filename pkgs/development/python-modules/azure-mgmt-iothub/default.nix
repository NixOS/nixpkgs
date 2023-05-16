{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
<<<<<<< HEAD
, pythonOlder
=======
, isPy3k
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "azure-mgmt-iothub";
<<<<<<< HEAD
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-enpNE5kVyGK+ctrGt1gt6633rNvT9FM76kSQ7prb1Wo=";
=======
    hash = "sha256-ml+koj52l5o0toAcnsGtsw0tGnO5F/LKq56ovzdmx/A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
<<<<<<< HEAD
=======
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure IoTHub Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
