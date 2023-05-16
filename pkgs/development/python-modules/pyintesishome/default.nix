{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pyintesishome";
<<<<<<< HEAD
  version = "1.8.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-QgIvIn8I5EtJSNj1FdOI+DPgG7/y2ToQ62dhk7flieo=";
=======
    hash = "sha256-+pXGB7mQszbBp4KhOYzDKoGFoUHATWLbOU6QwMIpGWU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;
<<<<<<< HEAD

  pythonImportsCheck = [
    "pyintesishome"
  ];
=======
  pythonImportsCheck = [ "pyintesishome" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python interface for IntesisHome devices";
    homepage = "https://github.com/jnimmo/pyIntesisHome";
<<<<<<< HEAD
    changelog = "https://github.com/jnimmo/pyIntesisHome/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
