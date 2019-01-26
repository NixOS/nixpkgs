{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pylru";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e03a3d354eb8fdfa11638698e8a1f06cd3b3a214ebc0a120c603a79290d9ebec";
  };

  meta = with lib; {
    homepage = https://github.com/jlhutch/pylru;
    description = "A least recently used (LRU) cache implementation";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
