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
  requests,
  sentencepiece,
  tqdm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gguf";
  version = "8147";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b${finalAttrs.version}";
    hash = "sha256-/r/lWt+G14BsNqTBqeK4Po4QHU0GkpEBbIvt5rqB4jc=";
  };

  sourceRoot = "${finalAttrs.src.name}/gguf-py";

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    pyside6
    pyyaml
    requests
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
})
