{ azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, lib
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-frontdoor";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    sha256 = "sha256-GqrJNNcQrNffgqRywgaJ2xkwy+fOJai/RlSVkpw6NWg=";
=======
    sha256 = "sha256-nJXQ/BpyOwmybNUqE4cBxq5xxZE56lqgHSTKZTIHIuU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.frontdoor" ];

  meta = with lib; {
    description = "Microsoft Azure Front Door Service Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
