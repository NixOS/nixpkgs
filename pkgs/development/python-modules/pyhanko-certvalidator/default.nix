{ lib
, aiohttp
, asn1crypto
, buildPythonPackage
, cryptography
, fetchFromGitHub
, freezegun
, oscrypto
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, setuptools
, uritools
}:

buildPythonPackage rec {
  pname = "pyhanko-certvalidator";
  version = "0.26.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certvalidator";
    rev = "refs/tags/v${version}";
    hash = "sha256-uUmsWiN182g+kxrCny7UNLDHdAdqKk64w6vnjmGBNjM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "pytest-runner",' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    asn1crypto
    cryptography
    oscrypto
    requests
    uritools
  ];

  nativeCheckInputs = [
    aiohttp
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
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
    # ValueError: Hash algorithm not known for ed448
    "test_ed"
  ];

  pythonImportsCheck = [
    "pyhanko_certvalidator"
  ];

  meta = with lib; {
    description = "Python library for validating X.509 certificates and paths";
    homepage = "https://github.com/MatthiasValvekens/certvalidator";
    changelog = "https://github.com/MatthiasValvekens/certvalidator/blob/v${version}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
