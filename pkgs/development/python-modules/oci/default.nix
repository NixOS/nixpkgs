{
  lib,
  buildPythonPackage,
  certifi,
  circuitbreaker,
  cryptography,
  fetchFromGitHub,
  pyopenssl,
  python-dateutil,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oci";
  version = "2.131.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-6JY5A0s4MY/AqFoUgpSFIDy8g/U8kkeM0YqLlp+Qmzs=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "pyOpenSSL"
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Oracle Cloud Infrastructure Python SDK";
    homepage = "https://github.com/oracle/oci-python-sdk";
    changelog = "https://github.com/oracle/oci-python-sdk/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [
      asl20 # or
      upl
    ];
    maintainers = with maintainers; [ ilian ];
  };
}
