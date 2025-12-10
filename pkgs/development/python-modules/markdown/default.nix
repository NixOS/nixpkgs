{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "markdown";
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-Markdown";
    repo = "markdown";
    tag = version;
    hash = "sha256-wrDS7ajP031YKejD9Y83xg5bMl8ihBMSVZGov+1Y7Kg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    unittestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "markdown" ];

  meta = {
    changelog = "https://github.com/Python-Markdown/markdown/blob/${src.tag}/docs/changelog.md";
    description = "Python implementation of John Gruber's Markdown";
    mainProgram = "markdown_py";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
