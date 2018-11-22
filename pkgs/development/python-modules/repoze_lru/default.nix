{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "repoze.lru";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f7a323bf716d3cb6cb3910cd4fccbee0b3d3793322738566ecce163b01bbd31";
  };

  meta = with stdenv.lib; {
    description = "A tiny LRU cache implementation and decorator";
    homepage = http://www.repoze.org/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
