{ lib
, buildPythonPackage
, fetchPypi
, cffi
, cryptography
, enum34
, idna
, ipaddress
, ndg-httpsclient
, pyopenssl
, pyasn1
, pycparser
, pycryptodomex
, requests
, six
}:

buildPythonPackage rec {
  version = "0.4.3";
  pname = "gpsoauth";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b38f654450ec55f130c9414d457355d78030a2c29c5ad8f20b28304a9fc8fad7";
  };

  propagatedBuildInputs = [ cffi cryptography enum34 idna ipaddress ndg-httpsclient pyopenssl pyasn1 pycparser pycryptodomex requests six ];

  # no tests executed
  doCheck = false;

  pythonImportsCheck = [ "gpsoauth" ];

  meta = with lib; {
    description = "A python client library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };

}
