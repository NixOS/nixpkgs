{ lib, stdenv, buildPythonPackage, fetchPypi
, dateutil, mock, isPy3k }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "8.1.0";

  meta = with lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  checkInputs = stdenv.lib.optional (!isPy3k) mock;

  src = fetchPypi {
    inherit pname version;
    sha256 = "246bf8d3611527030889e6df970878969d3a2f760ba3eb694fa1fb10e6ce53f9";
  };
}
