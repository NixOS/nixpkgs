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
    sha256 = "sha256-FbxSjKxhzlpj3IezuLCQvoeZMG1q+OE/yn5vB/XE1rI=";
  };

  propagatedBuildInputs = [
    certvalidator
    attrs
    six
    urllib3
    cryptoparser
    requests
  ];

  doCheck = false; # Tests require networking

  pythonImportsCheck = [ "cryptolyzer" ];

  meta = with lib; {
    description = "Fast and flexible cryptographic protocol analyzer";
    homepage = "https://gitlab.com/coroner/cryptolyzer";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
