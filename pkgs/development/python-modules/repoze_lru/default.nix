{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "repoze.lru";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0429a75e19380e4ed50c0694e26ac8819b4ea7851ee1fc7583c8572db80aff77";
  };

  pythonImportsCheck = [ "repoze.lru" ];

  meta = with lib; {
    description = "A tiny LRU cache implementation and decorator";
    homepage = "http://www.repoze.org/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
