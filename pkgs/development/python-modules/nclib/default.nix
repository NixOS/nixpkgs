{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nclib";
<<<<<<< HEAD
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sKbISlL5hOBu1j6zWSib2HjJCvEoMrqdwzgG2keMqDE=";
=======
  version = "1.0.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rA8oeYvMhw8HURxPLBRqpMHnAez/xBjyPFoKXIIvBjg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Project has no tests
  doCheck = false;
<<<<<<< HEAD

  pythonImportsCheck = [
    "nclib"
  ];
=======
  pythonImportsCheck = [ "nclib" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python module that provides netcat features";
    homepage = "https://nclib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
