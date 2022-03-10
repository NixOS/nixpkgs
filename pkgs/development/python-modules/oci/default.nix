{ lib
, buildPythonPackage
, certifi
, circuitbreaker
, configparser
, cryptography
, fetchFromGitHub
, pyopenssl
, python-dateutil
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "oci";
  version = "2.56.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    rev = "v${version}";
    hash = "sha256-olrWv4c2DoZ7ddm58Wpb5jZntw8WEKJ6IzAND11tdjk=";
  };

  propagatedBuildInputs = [
    certifi
    circuitbreaker
    configparser
    cryptography
    pyopenssl
    python-dateutil
    pytz
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "configparser==4.0.2 ; python_version < '3'" "configparser" \
      --replace "cryptography>=3.2.1,<=3.4.7" "cryptography" \
      --replace "pyOpenSSL>=17.5.0,<=19.1.0" "pyOpenSSL"
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
