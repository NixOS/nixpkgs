{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00mr9b15d539z89ng5nf89s2ryhk90xwx95jal77ma0wslixrk5d";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/scoder/fastrlock;
    description = "A fast RLock implementation for CPython";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
