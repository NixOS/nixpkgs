{ lib, buildPythonPackage, fetchPypi
, dateutil, mock, isPy3k }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "9.0.1";

  meta = with lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  checkInputs = lib.optional (!isPy3k) mock;

  src = fetchPypi {
    inherit pname version;
    sha256 = "72e3117667eedf66951bb2d93f4296a56b94b078a8a95905a052611fb3f1b973";
  };
}
