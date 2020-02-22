{ lib
, buildPythonPackage
, fetchPypi
, pytestrunner
, dateutil
, babelfish
, rebulk
}:

buildPythonPackage rec {
  pname = "guessit";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dcd3f2acaf6c1a864f903f084ddd6a6b753f3107ae864355d7c8c1e9cb205b2";
  };

  # Tests require more packages.
  doCheck = false;
  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [
    dateutil babelfish rebulk
  ];

  meta = {
    homepage = https://pypi.python.org/pypi/guessit;
    license = lib.licenses.lgpl3;
    description = "A library for guessing information from video files";
  };
}