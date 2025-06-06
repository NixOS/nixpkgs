{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

let
  pname = "lru-dict";
  version = "1.3.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VP0ZZta9H83ngVlsuGBoIU7e6/8dsTos6hEHnj/Qe2s=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lru" ];

  meta = with lib; {
    description = "Fast and memory efficient LRU cache for Python";
    homepage = "https://github.com/amitdev/lru-dict";
    changelog = "https://github.com/amitdev/lru-dict/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
