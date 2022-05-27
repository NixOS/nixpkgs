{ lib, fetchFromGitHub, buildPythonPackage
, lxml, pycryptodomex, construct
, argon2-cffi, python-dateutil, future
, python
}:

buildPythonPackage rec {
  pname   = "pykeepass";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "libkeepass";
    repo = "pykeepass";
    rev = "v${version}";
    hash = "sha256-q6cBowEki5iJh04Hp1jwbWdteEu3HXtD3tG/TsYDRNI=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  propagatedBuildInputs = [
    lxml pycryptodomex construct
    argon2-cffi python-dateutil future
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
