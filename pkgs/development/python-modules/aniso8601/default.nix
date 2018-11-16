{ stdenv, buildPythonPackage, fetchPypi
, dateutil }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "4.0.1";

  meta = with stdenv.lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "15cwnadw2xdczdi13k9grrgqq67hxgys4l155dqsl2zh3glhsmp7";
  };
}
