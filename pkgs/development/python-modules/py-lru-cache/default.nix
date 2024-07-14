{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "py-lru-cache";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "py_lru_cache";
    hash = "sha256-At8zaE4T4aeJh7+fiwrJAhCVKFfZ0S0c+D/QyQZFavA=";
  };

  meta = with lib; {
    description = "In-memory LRU cache for python";
    homepage = "https://github.com/stucchio/Python-LRU-cache";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
