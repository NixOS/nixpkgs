{ stdenv
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
  version = "0.4.1";
  pname = "gpsoauth";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c3f45824d45ac3d06b9d9a0c0eccafe1052505d31ac9a698aef8b00fb0dfc37";
  };

  propagatedBuildInputs = [ cffi cryptography enum34 idna ipaddress ndg-httpsclient pyopenssl pyasn1 pycparser pycryptodomex requests six ];

  meta = with stdenv.lib; {
    description = "A python client library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };

}
