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
  version = "2.1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f7e12b7f2215548284631a20aae6fc009c8af2bb8cc5d5e5e339cb15361dd95";
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