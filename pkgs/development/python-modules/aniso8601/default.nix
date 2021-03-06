{ lib, buildPythonPackage, fetchPypi
, dateutil, mock, isPy3k }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "8.1.1";

  meta = with lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  checkInputs = lib.optional (!isPy3k) mock;

  src = fetchPypi {
    inherit pname version;
    sha256 = "be08b19c19ca527af722f2d4ba4dc569db292ec96f7de963746df4bb0bff9250";
  };
}
