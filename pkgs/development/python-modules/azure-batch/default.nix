{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-batch";
<<<<<<< HEAD
  version = "14.0.0";
=======
  version = "13.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-FlsembhvghAkxProX7NIadQHqg67DKS5b7JthZwmyTQ=";
=======
    hash = "sha256-6Sld5wQE0nbtoN0iU9djl0Oavl2PGMH8oZnEm41q4wo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.batch"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Batch Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
