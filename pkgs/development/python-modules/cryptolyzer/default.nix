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
  version = "0.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "CryptoLyzer";
    inherit version;
    hash = "sha256-Bo8w9ijJu9IWdgr8OQws2iErzmuxUhs9YE6NAydPYgM=";
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
