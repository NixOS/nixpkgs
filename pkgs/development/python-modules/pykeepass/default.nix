{ lib, fetchFromGitHub, buildPythonPackage
, lxml, pycryptodomex, construct
<<<<<<< HEAD
, argon2-cffi, python-dateutil
=======
, argon2-cffi, python-dateutil, future
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python
}:

buildPythonPackage rec {
  pname   = "pykeepass";
<<<<<<< HEAD
  version = "4.0.6";
=======
  version = "4.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-832cTVzI/MFdwiw6xWzRG35z3iwqb5Qpf6W6XYBIFWs=";
  };

  propagatedBuildInputs = [
    lxml pycryptodomex construct
    argon2-cffi python-dateutil
=======
    hash = "sha256-HyveBBsd1OFWoY3PgqqaKRLBhsxgFv8PRAxEF6r+bf4=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  propagatedBuildInputs = [
    lxml pycryptodomex construct
    argon2-cffi python-dateutil future
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
