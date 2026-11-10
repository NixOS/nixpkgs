{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.4.1";
  format = "setuptools";
  pname = "httpauth";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C6rnFroAd5vOULBMwsLSyeSK5zPXOEgGHDSYt+Pm2dQ=";
  };

  doCheck = false;

  meta = {
    description = "WSGI HTTP Digest Authentication middleware";
    homepage = "https://github.com/jonashaag/httpauth";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
