{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pytest-mock
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "cert-chain-resolver";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rkoopmans";
    repo = "python-certificate-chain-resolver";
    rev = version;
    hash = "sha256-NLTRx6J6pjs7lyschHN5KtgrnpQpEyvZ2zz0pSd5sc4=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

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

  pythonImportsCheck = [
    "cert_chain_resolver"
  ];

  meta = with lib; {
    description = "Resolve / obtain the certificate intermediates of a x509 certificate";
    homepage = "https://github.com/rkoopmans/python-certificate-chain-resolver";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
