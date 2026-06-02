{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrsistent";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tobgu";
    repo = "pyrsistent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8fLyz8ELOg5GCrBHLSl4iiCgEZ6MuFoBwNKns5AI5Ps=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    typing-extensions
  ];

  pythonImportsCheck = [ "pyrsistent" ];

  meta = {
    homepage = "https://github.com/tobgu/pyrsistent/";
    description = "Persistent/Functional/Immutable data structures";
    changelog = "https://github.com/tobgu/pyrsistent/blob/${finalAttrs.src.tag}/CHANGES.txt";
    license = lib.licenses.mit;
  };
})
