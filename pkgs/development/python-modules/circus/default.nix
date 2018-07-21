{ buildPythonPackage, fetchPypi
, iowait, psutil, pyzmq, tornado, mock }:

buildPythonPackage rec {
  pname = "circus";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1603cf4c4f620ce6593d3d2a67fad25bf0242183ea24110d8bb1c8079c55d1b";
  };

  doCheck = false; # weird error

  propagatedBuildInputs = [ iowait psutil pyzmq tornado mock ];
}
