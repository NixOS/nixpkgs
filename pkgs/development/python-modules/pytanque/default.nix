{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  requests,
  typing-extensions,

  # tests
  coqPackages,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytanque";
  version = "0.2.2";
  pyproject = true;

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

  nativeCheckInputs = [
    # coq-lsp provides the pet and pet-server binaries the tests drive.
    coqPackages.coq-lsp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytanque" ];

  meta = {
    description = "Python client for the Petanque JSON-RPC interface to coq-lsp";
    homepage = "https://github.com/LLM4Rocq/pytanque";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
})
