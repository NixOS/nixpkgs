{ lib
, buildPythonPackage
, fetchFromGitHub
, cpyparsing
, ipykernel
, mypy
, pexpect
, pygments
, pytestCheckHook
, prompt-toolkit
, tkinter
, watchdog
}:

buildPythonPackage rec {
  pname = "coconut";
<<<<<<< HEAD
  version = "3.0.3";
=======
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-u1tcIu0U1VZrUx2hVdtRDv1N4jVf176kQSw47/7lOXY=";
=======
    hash = "sha256-+OrVNtre7kAfU5L7/6DadZxFNWVt5raF6HLGXHHpOvE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ cpyparsing ipykernel mypy pygments prompt-toolkit watchdog ];

  nativeCheckInputs = [ pexpect pytestCheckHook tkinter ];

  # Currently most tests have performance issues
  pytestFlagsArray = [
    "coconut/tests/constants_test.py"
  ];

  pythonImportsCheck = [ "coconut" ];

  meta = with lib; {
    homepage = "http://coconut-lang.org/";
    description = "Simple, elegant, Pythonic functional programming";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
