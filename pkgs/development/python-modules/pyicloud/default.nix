{
  lib,
  buildPythonPackage,
  certifi,
  click,
  fetchFromGitHub,
  fido2,
  keyring,
  keyrings-alt,
  protobuf,
  pydantic,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  rich,
  setuptools_80,
  setuptools-scm,
  srp,
  tinyhtml,
  typer,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyicloud";
  version = "2.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timlaing";
    repo = "pyicloud";
    tag = finalAttrs.version;
    hash = "sha256-wlBVQPGGt8Q6EeLceORfRn+MtRKtmum+z3WAG6ZR+2Q=";
  };

  build-system = [
    setuptools_80
    setuptools-scm
  ];

  dependencies = [
    certifi
    click
    fido2
    keyring
    keyrings-alt
    protobuf
    pydantic
    requests
    srp
    tinyhtml
    tzlocal
  ];

  pythonRelaxDeps = [ "tzlocal" ];

  optional-dependencies = {
    cli = [
      rich
      typer
    ];
  };

  nativeCheckInputs = [
    pytest-mock
    pytest-socket
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "pyicloud" ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/picklepete/pyicloud/issues/446
    "test_storage"
  ];

  meta = {
    description = "Module to interact with iCloud webservices";
    mainProgram = "icloud";
    homepage = "https://github.com/timlaing/pyicloud";
    changelog = "https://github.com/timlaing/pyicloud/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mic92 ];
  };
})
