{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
<<<<<<< HEAD
=======
, mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, responses
, typing-extensions
}:

buildPythonPackage rec {
  pname = "globus-sdk";
<<<<<<< HEAD
  version = "3.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "3.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-sdk-python";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-mKtqfEpnWftpGReaUrmXf3LftZnMtEizPi4RbIwgnUM=";
=======
    hash = "sha256-xdzDKzlqQRBrKT/j6PWSgDu33XlVHKsHfv5AgrT6SB8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cryptography
    requests
    pyjwt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
=======
    mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace setup.py \
    --replace "pyjwt[crypto]>=2.0.0,<3.0.0" "pyjwt[crypto]>=2.0.0,<3.0.0"
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "globus_sdk"
  ];

  meta = with lib; {
    description = "Interface to Globus REST APIs, including the Transfer API and the Globus Auth API";
    homepage =  "https://github.com/globus/globus-sdk-python";
    changelog = "https://github.com/globus/globus-sdk-python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
