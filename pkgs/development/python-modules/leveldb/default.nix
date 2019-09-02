{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "leveldb";
  version = "0.194";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f6d1y65k6miimic82n8zsx50z9k982mvzp90crwcv1knjrphcww";
  };

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/py-leveldb/";
    description = "Thread-safe Python bindings for LevelDB";
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.bsd3;
    maintainers = [ maintainers.aanderse ];
  };
}
