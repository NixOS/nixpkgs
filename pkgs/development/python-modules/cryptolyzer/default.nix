{ lib
, buildPythonPackage
, fetchPypi
, certvalidator
, attrs
, six
, urllib3
, cryptoparser
, requests
}:

buildPythonPackage rec {
  pname = "cryptolyzer";
  version = "0.8.1";

  src = fetchPypi {
    pname = "CryptoLyzer";
    inherit version;
    hash = "sha256-FbxSjKxhzlpj3IezuLCQvoeZMG1q+OE/yn5vB/XE1rI=";
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
    description = "Fast and flexible cryptographic protocol analyzer";
    homepage = "https://gitlab.com/coroner/cryptolyzer";
    changelog = "https://gitlab.com/coroner/cryptolyzer/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
