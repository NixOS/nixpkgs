{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "leveldb";
  version = "0.201";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HP/ndoQpF+CfBzvW6lhWxkE2rr3b5RvRfqKZE0cv7L8=";
  };

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/py-leveldb/";
    description = "Thread-safe Python bindings for LevelDB";
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    license = licenses.bsd3;
    maintainers = [ maintainers.aanderse ];
  };
}
