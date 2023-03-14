{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiohttp
, asn1crypto
, cryptography
, oscrypto
, requests
, uritools
, openssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyhanko-certvalidator";
  version = "0.19.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certvalidator";
    rev = version;
    sha256 = "sha256-UxlBggKgqvbKioG98UaKvhW0YgEa6PqV913nqYvTx1I=";
  };

  propagatedBuildInputs = [
    asn1crypto
    cryptography
    oscrypto
    requests
    uritools
  ];

  nativeCheckInputs = [
    aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Test looks for libcrypto.so.1.1
    "dev/stress_test.py"
    # Requests
    "tests/test_crl_client.py"
  ];

  disabledTests = [
    # Look for nonexisting certificates
    "test_basic_certificate_validator_tls"
    # Failed to fetch OCSP response from http://ocsp.digicert.com
    "test_fetch_ocsp_aiohttp"
    "test_fetch_ocsp_requests"
    "test_fetch_ocsp_err_requests"
    # Unable to build a validation path for the certificate "%s" - no issuer matching "%s" was found
    "test_revocation_mode_hard_aiohttp_autofetch"
    # The path could not be validated because no revocation information could be found for intermediate certificate 1
    "test_revocation_mode_hard"
    # certificate expired 2022-09-17
    "test_revocation_mode_soft"
  ];

  pythonImportsCheck = [
    "pyhanko_certvalidator"
  ];

  meta = with lib; {
    description = "Python library for validating X.509 certificates and paths";
    homepage = "https://github.com/MatthiasValvekens/certvalidator";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
