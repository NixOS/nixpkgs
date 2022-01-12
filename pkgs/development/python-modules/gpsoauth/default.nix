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
  version = "1.0.0";
  pname = "gpsoauth";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c4d6a980625b8ab6f6f1cf3e30d9b10a6c61ababb2b60bfe4870649e9c82be0";
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
