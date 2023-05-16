{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "commandparse";
<<<<<<< HEAD
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S9e90BtS6qMjFtYUmgC0w4IKQP8q1iR2tGqq5l2+n6o=";
=======
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06mcxc0vs5qdcywalgyx5zm18z4xcsrg5g0wsqqv5qawkrvmvl53";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # tests only distributed upstream source, not PyPi
  doCheck = false;
<<<<<<< HEAD

  pythonImportsCheck = [
    "commandparse"
  ];
=======
  pythonImportsCheck = [ "commandparse" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python module to parse command based CLI application";
    homepage = "https://github.com/flgy/commandparse";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
  };
}
