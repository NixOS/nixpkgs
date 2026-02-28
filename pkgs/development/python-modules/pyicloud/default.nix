{
  lib,
  buildPythonPackage,
  certifi,
  click,
  fetchFromGitHub,
  fido2,
  keyring,
  keyrings-alt,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  setuptools,
  setuptools-scm,
  srp,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyicloud";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timlaing";
    repo = "pyicloud";
    tag = finalAttrs.version;
    hash = "sha256-6Z5YhEqRzThQM5nHG0o+q4Rm/+A/ss3N6RDRz6mPJm4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 77.0,< 80.10" setuptools
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    certifi
    click
    fido2
    keyring
    keyrings-alt
    requests
    srp
    tzlocal
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-socket
    pytestCheckHook
  ];

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
