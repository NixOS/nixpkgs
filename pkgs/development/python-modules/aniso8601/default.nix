{ stdenv, buildPythonPackage, fetchPypi
, dateutil }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "2.0.1";
  name = "${pname}-${version}";

  meta = with stdenv.lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7215a41e5194a829dc87d1ea5039315be85a6158ba15c8157a284c29fa6808b";
  };
}
