{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cryptography,
  jinja2,
  mako,
  passlib,
  pyyaml,
  requests,
  rtoml,
  setuptools,
  tomlkit,
  librouteros,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bundlewrap";
  version = "4.21.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    rev = "refs/tags/${version}";
    hash = "sha256-e9gpWLOiTUZYIybLIfcR5x/NzhJSBFsU0I8LzY9sI5k=";
  };

  build-system = [ setuptools ];
  dependencies = [
    setuptools
    cryptography
    jinja2
    mako
    passlib
    pyyaml
    requests
    tomlkit
    librouteros
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
    mainProgram = "bw";
    license = [ licenses.gpl3 ];
    maintainers = with maintainers; [ wamserma ];
  };
}
