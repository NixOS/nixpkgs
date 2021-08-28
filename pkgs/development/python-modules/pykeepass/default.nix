{ lib, fetchFromGitHub, buildPythonPackage
, lxml, pycryptodomex, construct
, argon2_cffi, dateutil, future
, python
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    rev = version;
    sha256 = "1zw5hjk90zfxpgq2fz4h5qzw3kmvdnlfbd32gw57l034hmz2i08v";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  propagatedBuildInputs = [
    lxml pycryptodomex construct
    argon2_cffi dateutil future
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest tests.tests
  '';

  meta = with lib; {
    homepage = "https://github.com/libkeepass/pykeepass";
    changelog = "https://github.com/libkeepass/pykeepass/blob/${version}/CHANGELOG.rst";
    description = "Python library to interact with keepass databases (supports KDBX3 and KDBX4)";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
