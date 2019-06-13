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
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q06b3k31bfb8cxjimpf1rkcrwnc596a9cppjw15minvdangl32r";
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