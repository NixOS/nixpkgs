{ lib
, fetchFromGitHub
, buildPythonPackage
, certifi
, configparser
, cryptography
, pyopenssl
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  pname = "oci";
  version = "2.52.0";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    rev = "v${version}";
    hash = "sha256-4MlelzUPCJCZJQh8sNJHEL0WEcVWktV0TBEY0tdTHmk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "configparser==4.0.2" "configparser" \
      --replace "cryptography<=3.4.7,>=3.2.1" "cryptography" \
      --replace "pyOpenSSL>=17.5.0,<=19.1.0" "pyOpenSSL"
  '';

  propagatedBuildInputs = [
    certifi configparser cryptography pyopenssl python-dateutil pytz
  ];

  # Tests fail: https://github.com/oracle/oci-python-sdk/issues/164
  doCheck = false;

  pythonImportsCheck = [ "oci" ];

  meta = with lib; {
    description = "Oracle Cloud Infrastructure Python SDK";
    homepage = "https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/en/latest/index.html";
    maintainers = with maintainers; [ ilian ];
    license = with licenses; [ asl20 upl ];
  };
}
