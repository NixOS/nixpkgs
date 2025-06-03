{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-mock,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "cert-chain-resolver";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rkoopmans";
    repo = "python-certificate-chain-resolver";
    tag = version;
    hash = "sha256-2itpu/Ap5GNnqAiw3Cp+8rndreWlwfPd+WwM99G7U2E=";
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

  meta = with lib; {
    description = "Resolve / obtain the certificate intermediates of a x509 certificate";
    mainProgram = "cert-chain-resolver";
    homepage = "https://github.com/rkoopmans/python-certificate-chain-resolver";
    changelog = "https://github.com/rkoopmans/python-certificate-chain-resolver/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
