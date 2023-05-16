{ lib
, aiohttp
, attrs
, buildPythonPackage
, fetchPypi
, jmespath
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysma";
<<<<<<< HEAD
  version = "0.7.5";
=======
  version = "0.7.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-zlCGEcG5tmgEXhSMDLKj0/imT1iHBqlp1O1QhmPrJcA=";
=======
    hash = "sha256-4u564tLk91duYv1IClHddur6t+Rbla/e9P0yWAxw2sw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    jmespath
  ];

  # pypi does not contain tests and GitHub archive not available
  doCheck = false;

  pythonImportsCheck = [
    "pysma"
  ];

  meta = with lib; {
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
