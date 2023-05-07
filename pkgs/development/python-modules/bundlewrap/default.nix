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
  version = "4.17.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    rev = "refs/tags/${version}";
    hash = "sha256-0yg8+OflTF3pNYz2TPNUW8ubTZjrEgtihV/21PpJUlM=";
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
