{ stdenv, buildPythonPackage, fetchPypi
, dateutil, mock, isPy3k }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "8.0.0";

  meta = with stdenv.lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  checkInputs = stdenv.lib.optional (!isPy3k) mock;

  src = fetchPypi {
    inherit pname version;
    sha256 = "529dcb1f5f26ee0df6c0a1ee84b7b27197c3c50fc3a6321d66c544689237d072";
  };
}
