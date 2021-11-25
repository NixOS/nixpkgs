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
  version = "3.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "731e96e6a1f3b065d05accc8c19f35d4485d880b77ab8dc4b262cc353df294f7";
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
