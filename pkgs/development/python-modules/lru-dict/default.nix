{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

let
  pname = "lru-dict";
  version = "1.4.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zFGP8tOMx6irVvmmrlV/keLhUktX7Y5Zjpf0WivXCPw=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lru" ];

  meta = {
    description = "Fast and memory efficient LRU cache for Python";
    homepage = "https://github.com/amitdev/lru-dict";
    changelog = "https://github.com/amitdev/lru-dict/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
