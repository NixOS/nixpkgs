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
    sha256 = "0wnh6y96hi65cqfk59n31z2w75vinavq9vm1q3v0vvi6bwgwp7aj";
  };
}
