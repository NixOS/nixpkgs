{ stdenv
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0830r3q8f8mc4738ngcvwhv9kih5c6zf87mzkdifzf2h6kss99fl";
  };

  buildInputs = [ openssl ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bindings for scrypt key derivation function library";
    homepage = https://pypi.python.org/pypi/scrypt;
    maintainers = with maintainers; [ asymmetric ];
    license = licenses.bsd2;
  };
}
