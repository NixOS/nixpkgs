{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  requests,
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytanque";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "pytanque";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Hae21BuMdE6MjRdiBO7fcsuS4HzahOdLLhynAUox3I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests require a running pet-server (Petanque/coq-lsp).
  doCheck = false;

  pythonImportsCheck = [ "pytanque" ];

  meta = {
    description = "Python client for the Petanque JSON-RPC interface to coq-lsp";
    homepage = "https://github.com/LLM4Rocq/pytanque";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
})
