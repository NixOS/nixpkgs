{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

let
  pname = "lru-dict";
  version = "1.1.8";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h4vI70Bz5c+5U9/Bz0WF20HouBTAEGq9400A7g0LMRU=";
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
