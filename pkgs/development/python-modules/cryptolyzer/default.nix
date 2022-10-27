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
  version = "0.8.2";

  src = fetchPypi {
    pname = "CryptoLyzer";
    inherit version;
    sha256 = "sha256-Bo8w9ijJu9IWdgr8OQws2iErzmuxUhs9YE6NAydPYgM=";
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
