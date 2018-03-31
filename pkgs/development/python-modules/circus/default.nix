{ stdenv, buildPythonPackage, fetchPypi
, iowait, psutil, pyzmq, tornado, mock }:

buildPythonPackage rec {
  pname = "circus";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ip87wlq864k2rhk2r0rqq12ard1iggb61r6dsga4gh7lm538mrp";
  };

  doCheck = false; # weird error

  propagatedBuildInputs = [ iowait psutil pyzmq tornado mock ];
}
