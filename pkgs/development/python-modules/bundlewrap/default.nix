{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  cryptography,
  jinja2,
  librouteros,
  mako,
  packaging,
  passlib,
  pyyaml,
  requests,
  rtoml,
  setuptools,
  tomlkit,
  pytestCheckHook,
  versionCheckHook,
}:

let
  version = "4.23.1";
in
buildPythonPackage {
  pname = "bundlewrap";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    tag = version;
    hash = "sha256-Nzfx2L/FlYXQcbKq/cuRZ+PWnjv4HDld9q01nwQ1sA8=";
  };

  build-system = [ setuptools ];
  dependencies = [
    cryptography
    jinja2
    mako
    packaging
    passlib
    pyyaml
    requests
    tomlkit
    librouteros
  ]
  ++ lib.optionals (pythonOlder "3.11") [ rtoml ];

  pythonImportsCheck = [ "bundlewrap" ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bw";
  versionCheckProgramArg = "--version";

  enabledTestPaths = [
    # only unit tests as integration tests need a OpenSSH client/server setup
    "tests/unit"
  ];

  meta = {
    homepage = "https://bundlewrap.org/";
    description = "Easy, Concise and Decentralized Config management with Python";
    changelog = "https://github.com/bundlewrap/bundlewrap/blob/${version}/CHANGELOG.md";
    mainProgram = "bw";
    license = [ lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [ wamserma ];
  };
}
