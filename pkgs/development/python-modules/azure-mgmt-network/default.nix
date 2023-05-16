{ lib
<<<<<<< HEAD
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-network";
  version = "25.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rZPbkUQJFIeNSSPWHTK79INWeRX5+GJ7o7mEMLhyJ9E=";
=======
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  version = "22.2.0";
  pname = "azure-mgmt-network";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-491E1Q59dYFkH5QniR+S5eoiiL/ACwLe+fgYob8/jG4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
<<<<<<< HEAD
    isodate
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
=======
    msrest
    msrestazure
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [
    "azure.mgmt"
  ];

  pythonImportsCheck = [
    "azure.mgmt.network"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson jonringer ];
  };
}
