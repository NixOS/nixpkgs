{ lib, fetchFromGitHub, buildPythonPackage
, lxml, pycryptodomex, construct
, argon2-cffi, python-dateutil
, python
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "4.0.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    rev = "v${version}";
    hash = "sha256-832cTVzI/MFdwiw6xWzRG35z3iwqb5Qpf6W6XYBIFWs=";
  };

  propagatedBuildInputs = [
    lxml pycryptodomex construct
    argon2-cffi python-dateutil
  ];

  propagatedNativeBuildInputs = [ argon2-cffi ];

  checkPhase = ''
    ${python.interpreter} -m unittest tests.tests
  '';

  pythonImportsCheck = [ "pykeepass" ];

  meta = with lib; {
    homepage = "https://github.com/libkeepass/pykeepass";
    changelog = "https://github.com/libkeepass/pykeepass/blob/${src.rev}/CHANGELOG.rst";
    description = "Python library to interact with keepass databases (supports KDBX3 and KDBX4)";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
