{
  lib,
  buildPythonPackage,
  certifi,
  click,
  cryptography,
  fetchFromGitHub,
  fido2,
  keyring,
  keyrings-alt,
  protobuf,
  pydantic,
  pytest-socket,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  rich,
  setuptools,
  setuptools-scm,
  srp,
  tinyhtml,
  typer,
  typing-extensions,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyicloud";
  version = "2026.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timlaing";
    repo = "pyicloud";
    tag = finalAttrs.version;
    hash = "sha256-Bzv7wSCeB8h+V1TJMFjT3r972PghR5MNupoqf2rWPG4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    certifi
    cryptography
    fido2
    keyring
    keyrings-alt
    protobuf
    pydantic
    requests
    srp
    tinyhtml
    typing-extensions
    tzlocal
  ];

  pythonRelaxDeps = [ "tzlocal" ];

  optional-dependencies = {
    cli = [
      click
      rich
      typer
    ];
  };

  nativeCheckInputs = [
    pytest-socket
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "pyicloud" ];

  meta = {
    description = "Module to interact with iCloud webservices";
    mainProgram = "icloud";
    homepage = "https://github.com/timlaing/pyicloud";
    changelog = "https://github.com/timlaing/pyicloud/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mic92 ];
  };
})
