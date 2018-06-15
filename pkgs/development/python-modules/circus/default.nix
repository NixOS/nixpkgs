{ stdenv, buildPythonPackage, fetchPypi
, iowait, psutil, pyzmq, tornado, mock }:

buildPythonPackage rec {
  pname = "circus";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8ca91d8bd87b350fda199488ac9ddff91a546b0c6214a28a2f13393713cf062";
  };

  doCheck = false; # weird error

  propagatedBuildInputs = [ iowait psutil pyzmq tornado mock ];
}
