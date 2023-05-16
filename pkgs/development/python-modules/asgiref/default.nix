{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "3.7.2";
=======
  version = "3.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "asgiref";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-VW1PBh6+nLMD7qxmL83ymuxCPYKVY3qGKsB7ZiMqMu8=";
=======
    hash = "sha256-Kl4483rfuFKbnD7pBSTND1QAtBsZP6jKsrDlpVCZLDs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_multiprocessing"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "asgiref" ];

  meta = with lib; {
    changelog = "https://github.com/django/asgiref/blob/${src.rev}/CHANGELOG.txt";
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
