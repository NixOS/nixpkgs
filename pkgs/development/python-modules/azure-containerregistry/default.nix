<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-core
, msrest
, msrestazure
, isodate
=======
{ lib, buildPythonPackage, fetchPypi, pythonOlder
, azure-core
, msrest
, msrestazure
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "azure-containerregistry";
<<<<<<< HEAD
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ss0ygh0IZVPqvV3f7Lsh+5FbXRPvg3XRWvyyyAvclqM=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-core
    msrest
    msrestazure
    isodate
  ];
=======
  version = "1.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DIZCHZM5aeKtmJrgwAk5J26ltaxNxKUn3rR+FbmuyZc=";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-core msrest msrestazure ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tests require azure-devtools which are not published (since 2020)
  # https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/containerregistry/azure-containerregistry/dev_requirements.txt
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "azure.core"
    "azure.containerregistry"
  ];
=======
  pythonImportsCheck = [ "azure.core" "azure.containerregistry" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Microsoft Azure Container Registry client library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerregistry/azure-containerregistry";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
