{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, cryptography
, jinja2
, mako
, passlib
, pytest
, pyyaml
, requests
, rtoml
, setuptools
, tomlkit
, librouteros
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bundlewrap";
<<<<<<< HEAD
  version = "4.17.2";
=======
  version = "4.17.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-0yg8+OflTF3pNYz2TPNUW8ubTZjrEgtihV/21PpJUlM=";
=======
    hash = "sha256-hdTJcuhVMbLqtPclgj4u6XwH0A5DvnGpnkhIG6Gm8+4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    setuptools cryptography jinja2 mako passlib pyyaml requests tomlkit librouteros
  ] ++ lib.optionals (pythonOlder "3.11") [ rtoml ];

  pythonImportsCheck = [ "bundlewrap" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # only unit tests as integration tests need a OpenSSH client/server setup
    "tests/unit"
  ];

  meta = with lib; {
    homepage = "https://bundlewrap.org/";
    description = "Easy, Concise and Decentralized Config management with Python";
    license = [ licenses.gpl3 ] ;
    maintainers = with maintainers; [ wamserma ];
  };
}
