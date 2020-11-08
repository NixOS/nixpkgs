{ lib, fetchPypi, buildPythonPackage
, lxml, pycryptodomex, construct
, argon2_cffi, dateutil, future
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3e07eb2dd3aeb1dfa1a2d2d17be77066ee560c1e770f1c72d7ea5608117d284";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  requiredPythonModules = [
    lxml pycryptodomex construct
    argon2_cffi dateutil future
  ];

  # no tests in PyPI tarball
  doCheck = false;

  meta = {
    homepage = "https://github.com/pschmitt/pykeepass";
    description = "Python library to interact with keepass databases (supports KDBX3 and KDBX4)";
    license = lib.licenses.gpl3;
  };

}
