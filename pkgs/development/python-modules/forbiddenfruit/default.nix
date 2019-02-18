{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.1.2";
  pname = "forbiddenfruit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09ee1959fa34936c15417defa28bfd09cf88ad54c15454bc863d465ed42b8922";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  # tests directory missing in PyPI tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Patch python built-in objects";
    homepage = https://pypi.python.org/pypi/forbiddenfruit;
    license = licenses.mit;
  };

}
