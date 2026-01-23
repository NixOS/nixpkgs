{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  numpy,
  pyside6,
  pyyaml,
  sentencepiece,
  tqdm,

  # check inputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gguf";
  version = "0.17.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "gguf-v${version}";
    hash = "sha256-XjDMDca4pyc72WQee4h3R6Iq9M0LzO+6ukV6CBWQO1M=";
  };

  sourceRoot = "${src.name}/gguf-py";

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    pyside6
    pyyaml
    sentencepiece
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gguf" ];

  meta = {
    description = "Module for writing binary files in the GGUF format";
    homepage = "https://ggml.ai/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mitchmindtree
      sarahec
    ];
  };
}
