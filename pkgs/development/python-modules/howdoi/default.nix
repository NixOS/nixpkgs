{ stdenv, buildPythonPackage, fetchPypi
, six, requests-cache, pygments, pyquery }:

buildPythonPackage rec {
  pname = "howdoi";
  version = "1.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96f5e057fd45a84379d77e46233165d95211e6b3ea869cb5c0df172aa322b566";
  };

  propagatedBuildInputs = [ six requests-cache pygments pyquery ];

  meta = with stdenv.lib; {
    description = "Instant coding answers via the command line";
    homepage = https://pypi.python.org/pypi/howdoi;
    license = licenses.mit;
  };
}
