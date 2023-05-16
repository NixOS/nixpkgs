{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, python-socks, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-socks";
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
<<<<<<< HEAD
    hash = "sha256-duWEJDS5Ts3EWNRZ8MJcD7buMh3FRKA+bJiO3P7QWz0=";
=======
    hash = "sha256-knsdOzR0SPhv9SRcnKGeQPOX65OQZoK+WSeQZ4yYLzc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ aiohttp attrs python-socks ];

  # Checks needs internet access
  doCheck = false;
  pythonImportsCheck = [ "aiohttp_socks" ];

  disabled = pythonOlder "3.5.3";

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    license = lib.licenses.asl20;
    homepage = "https://github.com/romis2012/aiohttp-socks";
  };
}
