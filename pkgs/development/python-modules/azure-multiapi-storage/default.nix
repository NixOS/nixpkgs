{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
, msrestazure
, requests
}:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "azure-multiapi-storage";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-CQuoWHeh0EMitTRsvifotrTwpWd/Q9LWWD7jZ2w9r8I=";
=======
    hash = "sha256-x5v3e3/poSm+JMt0SWI1lcM6YAUcP+o2Sn8TluXOyIg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    msrestazure
    requests
  ];

  # fix namespace
  pythonNamespaces = [ "azure.multiapi" ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.multiapi.storage" ];

  meta = with lib; {
    description = "Microsoft Azure Storage Client Library for Python with multi API version support.";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
