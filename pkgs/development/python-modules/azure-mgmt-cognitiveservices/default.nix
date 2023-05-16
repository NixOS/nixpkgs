{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
<<<<<<< HEAD
  version = "13.5.0";
=======
  version = "13.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-RK8LGbH4J+nN6gnGBUweZgkqUcMrwe9aVtvZtAvFeBU=";
=======
    hash = "sha256-GQXDIWOiKGqZqrzpNfvDR8hTU4KnpjZQKrLivcD0tsA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Cognitive Services Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
