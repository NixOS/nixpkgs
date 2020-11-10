{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ae1a31f6e069b5f0f28ba63c594d0c952065de0a375f7b491d21ebaccc5166f";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/scoder/fastrlock";
    description = "A fast RLock implementation for CPython";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
