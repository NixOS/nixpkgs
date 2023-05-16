{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "3.2.0";
=======
  version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "azure-mgmt-kusto";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-zgkFMrufHoX3gq9QXo8SlJYZOfV5GlY3pVQXmIWyx7c=";
=======
    hash = "sha256-dkuVCFR+w3Yr764izDqxGfKtDvgRmAuziSPpkKDWcxc=";
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

  pythonImportsCheck = [ "azure.common" "azure.mgmt.kusto" ];

  meta = with lib; {
    description = "Microsoft Azure Kusto Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
