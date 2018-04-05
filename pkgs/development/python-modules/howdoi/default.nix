{ stdenv, buildPythonPackage, fetchPypi
, six, requests-cache, pygments, pyquery }:

buildPythonPackage rec {
  pname = "howdoi";
  version = "1.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dx9ms0b3z3bx02paj78cyi788d8l6cpd3jqbn3j88w736i4jknz";
  };

  propagatedBuildInputs = [ six requests-cache pygments pyquery ];

  meta = with stdenv.lib; {
    description = "Instant coding answers via the command line";
    homepage = https://pypi.python.org/pypi/howdoi;
    license = licenses.mit;
  };
}
