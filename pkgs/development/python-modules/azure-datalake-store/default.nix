{ lib
<<<<<<< HEAD
, adal
, azure-common
, buildPythonPackage
, fetchPypi
, msal
, pythonOlder
, requests
=======
, buildPythonPackage
, fetchPypi
, requests
, adal
, azure-common
, futures ? null
, pathlib2
, isPy3k
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "azure-datalake-store";
<<<<<<< HEAD
  version = "0.0.53";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BbbeYu4/KgpuaUHmkzt5K4AMPn9v/OL8MkvBmHV1c5M=";
  };

  propagatedBuildInputs = [
    adal
    azure-common
    msal
    requests
=======
  version = "0.0.52";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2";
  };

  propagatedBuildInputs = [
    requests
    adal
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    futures
    pathlib2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This project is the Python filesystem library for Azure Data Lake Store";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
