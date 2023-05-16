{ lib
, azure-common
, azure-core
, azure-storage-common
, buildPythonPackage
, cryptography
, fetchPypi
, isodate
, msrest
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
<<<<<<< HEAD
  version = "12.17.0";
=======
  version = "12.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-wUt4WhcFCzD8MmoxW9rmvEoHiFX0+UpMMDrXSkjcjGM=";
=======
    hash = "sha256-+LjVgkknQKsWdERVQINC+45MiJe2Soo/wxdDhEciwvI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-storage-common
    cryptography
    isodate
    msrest
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-storage-blob_${version}/sdk/storage/azure-storage-blob/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai maxwilson ];
  };
}
