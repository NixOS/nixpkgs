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

buildPythonPackage rec {
  pname = "pyicloud";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timlaing";
    repo = "pyicloud";
    tag = version;
    hash = "sha256-bGS5yAizdaZUdwKNoZPKP/DSpJs5XI70hyTLfJg9QmI=";
  };

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

  meta = with lib; {
    description = "Module to interact with iCloud webservices";
    mainProgram = "icloud";
    homepage = "https://github.com/timlaing/pyicloud";
    changelog = "https://github.com/timlaing/pyicloud/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
