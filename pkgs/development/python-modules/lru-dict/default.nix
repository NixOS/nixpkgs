{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:


buildPythonPackage (finalAttrs: {
  pname = "lru-dict";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amitdev";
    repo = "lru-dict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pHjBTAXoOUyTSzzHzOBZeMFkJhzspylMhxwqXYLFOQg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>="
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lru" ];

  meta = {
    description = "Fast and memory efficient LRU cache for Python";
    homepage = "https://github.com/amitdev/lru-dict";
    changelog = "https://github.com/amitdev/lru-dict/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
