{ lib, fetchPypi, buildPythonPackage
, lxml, pycryptodome, construct
, argon2_cffi, dateutil, future
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "280b0884243d059df888a61fd3fc77b2ea76dce4fdb1c1f60f3ab9139ca1259c";
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
