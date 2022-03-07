{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pylru";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R60UCmOrk4lkja37tDMHAOD/7rKOwEZk7kfTftEzsPQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/jlhutch/pylru";
    description = "A least recently used (LRU) cache implementation";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
