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
  pname = "azure-mgmt-redhatopenshift";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LOJldUyWdVShpN8lD8zGdFeYFiKSmODk3WNOP1fJfcs=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ]  ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
=======
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, isPy27
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "azure-mgmt-redhatopenshift";
  disabled = isPy27; # don't feel like fixing namespace issues on python2

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-ZU4mKTzny9tsKDrFSU+lll5v6oDivYJlXDriWJLAYec=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonNamespaces = "azure.mgmt";

<<<<<<< HEAD
  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.redhatopenshift"
  ];
=======
  # no included
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.redhatopenshift" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Microsoft Azure Red Hat Openshift Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
