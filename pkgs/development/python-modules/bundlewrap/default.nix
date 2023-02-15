{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, cryptography
, jinja2
, Mako
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
  version = "4.16.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    rev = version;
    sha256 = "sha256-y7h43D/SeXmMm0Fxi3hOOfXgDlmeoca11HOhGeJffRA=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    setuptools cryptography jinja2 Mako passlib pyyaml requests tomlkit librouteros
  ] ++ lib.optional (pythonOlder "3.11") [ rtoml ];

  pythonImportsCheck = [ "bundlewrap" ];

  checkInputs = [ pytestCheckHook ];

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
