{ lib, fetchPypi, buildPythonPackage
, lxml, pycryptodomex, construct
, argon2_cffi, dateutil, future
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b41b3277ea4e044556e1c5a21866ea4dfd36e69a4c0f14272488f098063178f";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  propagatedBuildInputs = [
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
