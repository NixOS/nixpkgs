{ stdenv, buildPythonPackage, fetchPypi
, dateutil }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "1.2.0";
  name = "${pname}-${version}";

  meta = with stdenv.lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "502400f82574afa804cc915d83f15c67533d364dcd594f8a6b9d2053f3404dd4";
  };
}
