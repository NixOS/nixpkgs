{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "py-lru-cache";
  version = "0.1.4";

  src = fetchPypi {
    inherit version;
    pname = "py_lru_cache";
    sha256 = "1w3a8l3ckl1zz0f2vlfrawl9a402r458p7xzhy4sgq8k9rl37pq2";
  };

  meta = with lib; {
    description = "An in-memory LRU cache for python";
    homepage = https://github.com/stucchio/Python-LRU-cache;
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };

}
