{ stdenv
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8239b2d47fa1d40bc27efd231dc7083695d10c1c2ac51a99380360741e0362d";
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
