{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

let
  pname = "lru-dict";
  version = "1.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E8VngvGdaN302NsBcAQRkoWWFlFMcGsSbQ3y7HKhG9c=";
  };

  nativeCheckInputs = [
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
