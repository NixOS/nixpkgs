{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyemby";
<<<<<<< HEAD
  version = "1.9";
=======
  version = "1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-4mOQLfPbRzZzpNLvekJHVKiqdGGKPhW6BpKkyRfk2Pc=";
=======
    hash = "sha256-EpmXdyKtfb/M8rTv6YrfNCpDmKei2AD5DBcdVvqCVWw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyemby" ];

  meta = with lib; {
    description = "Python library to interface with the Emby API";
    homepage = "https://github.com/mezz64/pyemby";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
