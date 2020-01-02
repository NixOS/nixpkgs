{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "leveldb";
  version = "0.201";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gzc5x3i76d2gv8iprfvpnp3chf6arcfmmiv0ygy05r9hivfgzqw";
  };

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/py-leveldb/";
    description = "Thread-safe Python bindings for LevelDB";
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.bsd3;
    maintainers = [ maintainers.aanderse ];
  };
}
