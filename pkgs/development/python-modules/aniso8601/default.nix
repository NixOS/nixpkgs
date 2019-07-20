{ stdenv, buildPythonPackage, fetchPypi
, dateutil, mock, isPy3k }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "7.0.0";

  meta = with stdenv.lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  checkInputs = stdenv.lib.optional (!isPy3k) mock;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07jgf55yq2j2q76gaj3hakflnxg8yfkarzvrmq33i1dp6xk2ngai";
  };
}
