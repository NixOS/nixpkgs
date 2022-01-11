{ buildPythonPackage
, click
, ecdsa
, fetchPypi
, fido2
, intelhex
, lib
, pyserial
, pyusb
, requests
}:

buildPythonPackage rec {
  pname = "onlykey-solo-python";
  version = "0.0.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Mbi5So2OgeXjg4Fzg7v2gAJuh1Y7ZCYu8Lrha/7PQfY=";
  };

  propagatedBuildInputs = [ click ecdsa fido2 intelhex pyserial pyusb requests ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "solo" ];

  meta = with lib; {
    homepage = "https://github.com/trustcrypto/onlykey-solo-python";
    description = "Python library for OnlyKey with Solo FIDO2";
    maintainers = with maintainers; [ kalbasit ];
    license = licenses.asl20;
  };
}

