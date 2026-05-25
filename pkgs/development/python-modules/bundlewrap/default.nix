{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  bcrypt,
  cryptography,
  jinja2,
  librouteros,
  mako,
  packaging,
  pyyaml,
  requests,
  setuptools,
  tomlkit,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bundlewrap";
  version = "5.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bundlewrap";
    repo = "bundlewrap";
    tag = finalAttrs.version;
    hash = "sha256-gncxzeAlfob0dXZ1iqMwqG5h+OyGxvPhrS0MZ+x0mbo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bcrypt
    cryptography
    jinja2
    mako
    packaging
    pyyaml
    requests
    tomlkit
    librouteros
  ];

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
