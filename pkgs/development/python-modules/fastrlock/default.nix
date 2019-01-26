{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6abdbb35205792e2d2a8c441aaa41a613d43ee2d88b3af4fd9735ae7a5f7db6b";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/scoder/fastrlock;
    description = "A fast RLock implementation for CPython";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
