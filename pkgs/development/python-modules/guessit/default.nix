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
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c530pb0h34z0ziym256qps21b8mh533ia1lcnx9wqwx9rnqriki";
  };

  # Tests require more packages.
  doCheck = false;
  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [
    dateutil babelfish rebulk
  ];

  meta = {
    homepage = "https://pypi.python.org/pypi/guessit";
    license = lib.licenses.lgpl3;
    description = "A library for guessing information from video files";
  };
}
