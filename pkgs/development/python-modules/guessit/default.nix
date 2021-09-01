{ lib
, buildPythonPackage
, fetchPypi
, pytest-runner
, python-dateutil
, babelfish
, rebulk
}:

buildPythonPackage rec {
  pname = "guessit";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8305e0086129614a8820a508303f98f56c584811489499bcc54a7ea6f1b0391e";
  };

  # Tests require more packages.
  doCheck = false;
  buildInputs = [ pytest-runner ];
  propagatedBuildInputs = [
    python-dateutil babelfish rebulk
  ];

  meta = {
    homepage = "https://pypi.python.org/pypi/guessit";
    license = lib.licenses.lgpl3;
    description = "A library for guessing information from video files";
  };
}
