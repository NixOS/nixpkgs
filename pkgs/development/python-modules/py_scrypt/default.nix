{ lib
, buildPythonPackage
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "scrypt";
  version = "0.8.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad143035ae0cf5e97c4b399f4e4686adf442c5f0f06f9f198a0cc6c091335fb7";
  };

  buildInputs = [ openssl ];
  doCheck = false;

  meta = with lib; {
    description = "Bindings for scrypt key derivation function library";
    homepage = "https://pypi.python.org/pypi/scrypt";
    maintainers = [];
    license = licenses.bsd2;
  };
}
