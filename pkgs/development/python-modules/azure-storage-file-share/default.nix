{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-core
, cryptography
, isodate
, msrest
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-storage-file-share";
<<<<<<< HEAD
  version = "12.13.0";
=======
  version = "12.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-ozqVIWPvAl0doaqK77P+VBhx9q+6Ljk/q7WrAP2ZPm8=";
=======
    hash = "sha256-z35H90n8Buy5m2RhKrS9lCJ7mTFJekwnwoZXF8PaoIk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-core
    cryptography
    isodate
    msrest
    typing-extensions
  ];

  # requires checkout from monorepo
  doCheck = false;

  pythonImportsCheck = [
    "azure.core"
    "azure.storage"
  ];

  meta = with lib; {
    description = "Microsoft Azure File Share Storage Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
