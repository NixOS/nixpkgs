{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "lru-dict";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "365457660e3d05b76f1aba3e0f7fedbfcd6528e97c5115a351ddd0db488354cc";
  };

  propagatedBuildInputs = [ ];

  pythonImportsCheck = [ "lru" ];

  meta = with lib; {
    description = "A fast and memory efficient LRU cache for Python";
    homepage = "https://github.com/amitdev/lru-dict/";
    license = licenses.mit;
    maintainers = with maintainers; [ sohalt ];
  };
}
