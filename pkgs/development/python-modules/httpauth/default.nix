{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.4";
  format = "setuptools";
  pname = "httpauth";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lehPEuxYV4SQsdL1RWBqTNFIGz2pSoTs+nlkQ5fPX8M=";
  };

  doCheck = false;

  meta = with lib; {
    description = "WSGI HTTP Digest Authentication middleware";
    homepage = "https://github.com/jonashaag/httpauth";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
