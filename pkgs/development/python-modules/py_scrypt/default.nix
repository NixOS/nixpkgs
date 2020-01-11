{ stdenv
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1377b1adc98c4152694bf5d7e93b41a9d2e9060af69b747cfad8c93ac426f9ea";
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
