{ lib, fetchPypi, buildPythonPackage
, lxml, pycryptodome, construct
, argon2_cffi, dateutil, future
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c9e2ddb03ee696ed8aa72c2cddfb81280614864e003226141d68b975aa56f6f";
  };

  propagatedBuildInputs = [
    lxml pycryptodome construct
    argon2_cffi dateutil future
  ];

  # no tests in PyPI tarball
  doCheck = false;

  meta = {
    homepage = https://github.com/pschmitt/pykeepass;
    description = "Python library to interact with keepass databases (supports KDBX3 and KDBX4)";
    license = lib.licenses.gpl3;
  };

}
