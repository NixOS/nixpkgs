{ stdenv, buildPythonPackage, fetchPypi
, dateutil }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "1.2.1";
  name = "${pname}-${version}";

  meta = with stdenv.lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7ba4f42d3aea75909c79b1f4c4614768b4f13fbb98fc658a7b6061ddb0be47c";
  };
}
