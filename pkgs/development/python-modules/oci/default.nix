{
  lib,
  buildPythonPackage,
  certifi,
  circuitbreaker,
  cryptography,
  fetchFromGitHub,
  pyopenssl,
  python-dateutil,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oci";
  version = "2.160.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    tag = "v${version}";
    hash = "sha256-Nz3/aGumNTMItE/HL5tAdh0QbZngeO02CfJKq4GZ+qY=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "pyOpenSSL"
  ];

  build-system = [ setuptools ];

  dependencies = [
    certifi
    circuitbreaker
    cryptography
    pyopenssl
    python-dateutil
    pytz
  ];

  # Tests fail: https://github.com/oracle/oci-python-sdk/issues/164
  doCheck = false;

  pythonImportsCheck = [ "oci" ];

  meta = {
    description = "Oracle Cloud Infrastructure Python SDK";
    homepage = "https://github.com/oracle/oci-python-sdk";
    changelog = "https://github.com/oracle/oci-python-sdk/blob/${src.tag}/CHANGELOG.rst";
    license = with lib.licenses; [
      asl20 # or
      upl
    ];
    maintainers = with lib.maintainers; [
      ilian
    ];
  };
}
