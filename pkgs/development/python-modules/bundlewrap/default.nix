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

buildPythonPackage (finalAttrs: {
  pname = "bundlewrap";
  version = "4.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    tag = finalAttrs.version;
    hash = "sha256-ayLceqYZC4cNuz9C6v2+W2TuiGWQeLMssbvwZ0N0n78=";
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

  enabledTestPaths = [
    # only unit tests as integration tests need a OpenSSH client/server setup
    "tests/unit"
  ];

  meta = {
    homepage = "https://bundlewrap.org/";
    description = "Easy, Concise and Decentralized Config management with Python";
    changelog = "https://github.com/bundlewrap/bundlewrap/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "bw";
    license = [ lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [ wamserma ];
  };
})
