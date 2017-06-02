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
  version = "2.1.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2eebbb61e4d2b3764ce4462e0b27da0dccbb25b78e13493a2f913a402e1d0fb";
  };

  # Tests require more packages.
  doCheck = false;
  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [
    dateutil babelfish rebulk
  ];

  meta = {
    homepage = http://pypi.python.org/pypi/guessit;
    license = lib.licenses.lgpl3;
    description = "A library for guessing information from video files";
  };
}