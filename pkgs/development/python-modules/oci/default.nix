{ lib
, buildPythonPackage
, certifi
, circuitbreaker
, cryptography
, fetchFromGitHub
, pyopenssl
, python-dateutil
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "oci";
  version = "2.78.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-24V9vfuNMxvC5iqluW4xz7WICXbQA89xmiAH6tIDRw0=";
  };

  propagatedBuildInputs = [
    certifi
    circuitbreaker
    cryptography
    pyopenssl
    python-dateutil
    pytz
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "configparser==4.0.2 ; python_version < '3'" "" \
      --replace "cryptography>=3.2.1,<=37.0.2" "cryptography" \
      --replace "pyOpenSSL>=17.5.0,<=22.0.0" "pyOpenSSL"
  '';

  # Tests fail: https://github.com/oracle/oci-python-sdk/issues/164
  doCheck = false;

  pythonImportsCheck = [
    "oci"
  ];

  meta = with lib; {
    description = "Oracle Cloud Infrastructure Python SDK";
    homepage = "https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/";
    license = with licenses; [ asl20 /* or */ upl ];
    maintainers = with maintainers; [ ilian ];
  };
}
