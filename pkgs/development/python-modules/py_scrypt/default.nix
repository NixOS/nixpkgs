{ stdenv
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25b5075f2238be93af1cd574540a5ea01b8547f9b678aa72d22fce22577475ec";
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
