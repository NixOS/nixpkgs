{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cryptography,
  jinja2,
  mako,
  passlib,
  pytest,
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
  version = "4.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    rev = "refs/tags/${version}";
    hash = "sha256-7jBFeJem+0vZot+BknKmCxozmoHCBCAZqDbfQQG3/Vw=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
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
