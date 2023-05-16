{ lib
, buildPythonPackage
, fetchPypi
, async-timeout
, pysnmplib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atenpdu";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Of7tQJNqaLDgO8nie6rSd1saMbauXJBp8vWfXYAziEE=";
=======
    hash = "sha256-E/cRjbispHiS38BdIvOKD4jOFrDmpx8L4eAlMV8Re70=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    async-timeout
    pysnmplib
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "atenpdu"
  ];

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
