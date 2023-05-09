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
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "CryptoLyzer";
    inherit version;
    hash = "sha256-677QyeBpXrt1J2fHE1yIH1NkXYUc7XjerXbp5Un3oc0=";
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
