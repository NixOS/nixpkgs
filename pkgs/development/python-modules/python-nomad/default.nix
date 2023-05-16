<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5IyHNw1ArE8fU9DoSQMGkDI9d/OiR1YI/7nTPeFIK+A=";
  };

  propagatedBuildInputs = [
    requests
  ];
=======
{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VpngJvm9eK60lPeFIbjnTwzWWoJ9tRBDYP5SghDMbAg=";
  };

  propagatedBuildInputs = [ requests ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests require nomad agent
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "nomad"
  ];
=======
  pythonImportsCheck = [ "nomad" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python client library for Hashicorp Nomad";
    homepage = "https://github.com/jrxFive/python-nomad";
<<<<<<< HEAD
    changelog = "https://github.com/jrxFive/python-nomad/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ xbreak ];
  };
}
