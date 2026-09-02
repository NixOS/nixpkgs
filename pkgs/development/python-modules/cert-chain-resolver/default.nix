{
  lib,
  buildPythonPackage,
  cacert,
  cryptography,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-mock,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "cert-chain-resolver";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rkoopmans";
    repo = "python-certificate-chain-resolver";
    tag = finalAttrs.version;
    hash = "sha256-DWE+mR7EO5ohuRAR0WC40GBY7HpwXIpU0hhVUnWNRno=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    six
  ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  disabledTests = [
    # Tests require network access
    "test_cert_returns_completed_chain"
    "test_display_flag_is_properly_formatted"
    "test_display_flag_includes_warning_when_root_was_requested_but_not_found"
  ];

  pythonImportsCheck = [ "cert_chain_resolver" ];

  meta = {
    description = "Resolve / obtain the certificate intermediates of a x509 certificate";
    mainProgram = "cert-chain-resolver";
    homepage = "https://github.com/rkoopmans/python-certificate-chain-resolver";
    changelog = "https://github.com/rkoopmans/python-certificate-chain-resolver/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
})
