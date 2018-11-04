{ stdenv, buildPythonPackage, fetchPypi
, six, requests-cache, pygments, pyquery }:

buildPythonPackage rec {
  pname = "howdoi";
  version = "1.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b85b8e551bf47ff157392660f0fc5b9eb3eacb78516a5823f7b774ec61955db5";
  };

  propagatedBuildInputs = [ six requests-cache pygments pyquery ];

  meta = with stdenv.lib; {
    description = "Instant coding answers via the command line";
    homepage = https://pypi.python.org/pypi/howdoi;
    license = licenses.mit;
  };
}
