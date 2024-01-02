{ lib
, attrs
, buildPythonPackage
, certvalidator
, cryptoparser
, fetchPypi
, pythonOlder
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "cryptolyzer";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "CryptoLyzer";
    inherit version;
    hash = "sha256-XiMkZeIjTAv8F84eutZoezZl4bJ2xqh4uwroDU24jjg=";
  };

  propagatedBuildInputs = [
    certvalidator
    attrs
    six
    urllib3
    cryptoparser
    requests
  ];

  # Tests require networking
  doCheck = false;

  pythonImportsCheck = [
    "cryptolyzer"
  ];

  meta = with lib; {
    description = "Cryptographic protocol analyzer";
    homepage = "https://gitlab.com/coroner/cryptolyzer";
    changelog = "https://gitlab.com/coroner/cryptolyzer/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
