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
  version = "2.1.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90e6f9fb49246ad27f34f8b9984357e22562ccc3059241cbc08b4fac1d401c56";
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