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
  pythonOlder,
  pyyaml,
  requests,
  requests-credssp,
  xmldiff,
}:

buildPythonPackage rec {
  pname = "pypsrp";
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Pwfc9e39sYPdcHN1cZtxxGEglEYzPp4yOYLD5/4SSiU=";
  };

  propagatedBuildInputs = [
    cryptography
    httpcore
    httpx
    psrpcore
    pyspnego
    requests
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    pyyaml
    xmldiff
  ];

  optional-dependencies = {
    credssp = [ requests-credssp ];
    kerberos = pyspnego.optional-dependencies.kerberos;
    named_pipe = [ psutil ];
    ssh = [ asyncssh ];
  };

  pythonImportsCheck = [ "pypsrp" ];

  disabledTests = [
    # TypeError: Backend.load_rsa_private_numbers() missing 1 required...
    "test_psrp_pshost_ui_mocked_methods"
    "test_psrp_key_exchange_timeout"
    "test_psrp_multiple_commands"
  ];

  meta = with lib; {
    description = "PowerShell Remoting Protocol Client library";
    homepage = "https://github.com/jborean93/pypsrp";
    changelog = "https://github.com/jborean93/pypsrp/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
