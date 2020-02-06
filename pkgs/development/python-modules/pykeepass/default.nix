{ lib, fetchPypi, buildPythonPackage
, lxml, pycryptodome, construct
, argon2_cffi, dateutil, future
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ysjn92bixq8wkwhlbhrjj9z0h80qnlnj7ks5478ndkzdw5gxvm1";
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
