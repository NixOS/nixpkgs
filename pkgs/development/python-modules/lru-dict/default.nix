{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

let
  pname = "lru-dict";
  version = "1.1.7";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RbgfZ9dTQdRDOrreeZpH6cQqniKhGFMdy15UmGQDLXw=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lru"
  ];

  meta = with lib; {
    description = "Fast and memory efficient LRU cache for Python";
    homepage = "https://github.com/amitdev/lru-dict";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
