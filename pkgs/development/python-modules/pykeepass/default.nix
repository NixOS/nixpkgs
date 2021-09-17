{ lib, fetchFromGitHub, buildPythonPackage
, lxml, pycryptodomex, construct
, argon2_cffi, python-dateutil, future
, python
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    rev = version;
    sha256 = "sha256-D+loaPBpKdXyiqpdth3ANDjH6IewuKYhj/DzRE2hDn4=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  propagatedBuildInputs = [
    lxml pycryptodomex construct
    argon2_cffi python-dateutil future
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
