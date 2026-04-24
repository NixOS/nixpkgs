{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  typing-extensions,
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

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    typing-extensions
  ];

  doCheck = false;

  pythonImportsCheck = [ "pytanque" ];

  meta = {
    description = "Python API for lightweight communication with the Rocq proof assistant via coq-lsp";
    homepage = "https://github.com/LLM4Rocq/pytanque";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ damhiya ];
  };
})
