{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-mock,
  six,
}:

buildPythonPackage rec {
  pname = "cert-chain-resolver";
  version = "1.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rkoopmans";
    repo = "python-certificate-chain-resolver";
    tag = version;
    hash = "sha256-DWE+mR7EO5ohuRAR0WC40GBY7HpwXIpU0hhVUnWNRno=";
  };

  propagatedBuildInputs = [ cryptography ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    six
  ];

  disabledTests = [
    # Tests require network access
    "test_cert_returns_completed_chain"
    "test_display_flag_is_properly_formatted"
  ];

  pythonImportsCheck = [ "cert_chain_resolver" ];

  meta = {
    description = "Resolve / obtain the certificate intermediates of a x509 certificate";
    mainProgram = "cert-chain-resolver";
    homepage = "https://github.com/rkoopmans/python-certificate-chain-resolver";
    changelog = "https://github.com/rkoopmans/python-certificate-chain-resolver/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
}
