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
, pycryptodome
, requests
, six
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "gpsoauth";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01zxw8rhml8xfwda7ba8983890bzwkfa55ijd6qf8qrdy6ja1ncn";
  };

  propagatedBuildInputs = [ cffi cryptography enum34 idna ipaddress ndg-httpsclient pyopenssl pyasn1 pycparser pycryptodome requests six ];

  meta = with stdenv.lib; {
    description = "A python client library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };

}
