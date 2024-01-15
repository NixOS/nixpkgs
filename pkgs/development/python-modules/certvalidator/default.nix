{ lib, buildPythonPackage, fetchFromGitHub
, asn1crypto, oscrypto
, cacert
}:

buildPythonPackage rec {
  pname = "certvalidator";
  version = "0.11.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wbond";
    repo = pname;
    rev = version;
    hash = "sha256-yVF7t4FuU3C9fDg67JeM7LWZZh/mv5F4EKmjlO4AuBY=";
  };

  propagatedBuildInputs = [ asn1crypto oscrypto ];

  nativeCheckInputs = [ cacert ];
  checkPhase = ''
    # Tests are run with a custom executor/loader
    # The regex to skip specific tests relies on negative lookahead of regular expressions
    # We're skipping the few tests that rely on the network, fetching CRLs, OCSP or remote certificates
    python -c 'import dev.tests; dev.tests.run("^(?!.*test_(basic_certificate_validator_tls|fetch|revocation|build_path)).*$")'
  '';
  pythonImportsCheck = [ "certvalidator" ];

  meta = with lib; {
    homepage = "https://github.com/wbond/certvalidator";
    description = "Validates X.509 certificates and paths";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
  };
}
