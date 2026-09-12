{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "compressed-rtf";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "delimitry";
    repo = "compressed_rtf";
    tag = finalAttrs.version;
    hash = "sha256-eQ1rX+IyQG6oStd+ELIMNJ3EjTKJTA3tHzuxdIuKgGs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "compressed_rtf" ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    changelog = "https://github.com/delimitry/compressed_rtf/releases/tag/${finalAttrs.src.tag}";
    description = "Compressed Rich Text Format (RTF) compression and decompression";
    homepage = "https://github.com/delimitry/compressed_rtf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
