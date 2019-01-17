{ stdenv, buildPythonPackage, fetchPypi
, dateutil, mock, isPy3k }:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "4.1.0";

  meta = with stdenv.lib; {
    description = "Parses ISO 8601 strings.";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
  };

  propagatedBuildInputs = [ dateutil ];

  checkInputs = stdenv.lib.optional (!isPy3k) mock;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x49k287ky1spv3msc9fwmc7ydyw6rlcr14nslgcmpjfn3pgzh03";
  };
}
