{
  lib,
  asyncssh,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  httpcore,
  httpx,
  psrpcore,
  psutil,
  pyspnego,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  requests,
  requests-credssp,
  setuptools,
  xmldiff,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypsrp";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "pypsrp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EFe587tLTlNEzxhACtlbB0FspDOUvfF3ly0DRtAomuY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    httpcore
    httpx
    psrpcore
    pyspnego
    requests
  ];

  optional-dependencies = {
    credssp = [ requests-credssp ];
    kerberos = pyspnego.optional-dependencies.kerberos;
    named_pipe = [ psutil ];
    ssh = [ asyncssh ];
  };

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    pyyaml
    xmldiff
  ];

  pythonImportsCheck = [ "pypsrp" ];

  disabledTests = [
    # TypeError: Backend.load_rsa_private_numbers() missing 1 required...
    "test_psrp_pshost_ui_mocked_methods"
    "test_psrp_key_exchange_timeout"
    "test_psrp_multiple_commands"
  ];

  meta = {
    description = "PowerShell Remoting Protocol Client library";
    homepage = "https://github.com/jborean93/pypsrp";
    changelog = "https://github.com/jborean93/pypsrp/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
