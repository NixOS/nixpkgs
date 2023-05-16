{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, prompt-toolkit
}:

buildPythonPackage rec {
  pname = "clintermission";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sebageek";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-e7C9IDr+mhVSfU8lMywjX1BYwFo/qegPNzabak7UPcY=";
=======
    hash = "sha256-HPeO9K91a0MacSUN0SR0lPEWRTQgP/cF1FZaNvZLxAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    prompt-toolkit
  ];

  # repo contains no tests
  doCheck = false;

  pythonImportsCheck = [
    "clintermission"
  ];

  meta = with lib; {
    description = "Non-fullscreen command-line selection menu";
    homepage = "https://github.com/sebageek/clintermission";
    changelog = "https://github.com/sebageek/clintermission/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
