{ stdenv
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0643fwj8vl96bsl30jx091zicmwyi0gglza66xqhqizqyqjq0ag6";
  };

  buildInputs = [ openssl ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bindings for scrypt key derivation function library";
    homepage = "https://pypi.python.org/pypi/scrypt";
    maintainers = [];
    license = licenses.bsd2;
  };
}
