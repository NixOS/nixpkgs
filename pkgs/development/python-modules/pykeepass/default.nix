{ lib, fetchPypi, buildPythonPackage
, lxml, pycryptodome, construct
, argon2_cffi, dateutil, enum34
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kfnh42nimsbdpwpny2c9df82b2n4fb5fagh54ck06f3x483vd90";
  };

  propagatedBuildInputs = [
    lxml pycryptodome construct
    argon2_cffi dateutil enum34
  ];

  meta = {
    homepage = https://github.com/pschmitt/pykeepass;
    description = "Python library to interact with keepass databases (supports KDBX3 and KDBX4)";
    license = lib.licenses.gpl3;
  };

}
