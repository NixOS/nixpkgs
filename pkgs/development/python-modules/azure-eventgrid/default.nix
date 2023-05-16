{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, azure-core
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-eventgrid";
<<<<<<< HEAD
  version = "4.13.0";
=======
  version = "4.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-Za/cyt/tCvzLTfIgS5Ifjbb9jPtdCojNzzI5WeBiO6I=";
=======
    hash = "sha256-PWl+rA/JAe0rUKU24oQuYlt7U4Cyi14T7cVlA/B60VY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    msrestazure
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.eventgrid"
  ];

  meta = with lib; {
    description = "A fully-managed intelligent event routing service that allows for uniform event consumption using a publish-subscribe model";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
