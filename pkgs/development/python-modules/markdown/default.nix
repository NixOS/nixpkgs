{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "markdown";
  version = "3.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-Markdown";
    repo = "markdown";
    tag = finalAttrs.version;
    hash = "sha256-3tgkMM0BlfmZWTEK+DoZsAMgjIj2KS/DvbqcOCD4rao=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    unittestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "markdown" ];

  meta = {
    changelog = "https://github.com/Python-Markdown/markdown/blob/${finalAttrs.src.tag}/docs/changelog.md";
    description = "Python implementation of John Gruber's Markdown";
    mainProgram = "markdown_py";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
