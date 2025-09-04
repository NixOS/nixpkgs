{
  lib,
  # Build system
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # Dependencies
  transformers,
  datasets,
  accelerate,
  sentence-transformers,
  peft,
  sentencepiece,
  protobuf,
  ir-datasets,
}:
buildPythonPackage rec {
  pname = "flag-embedding";
  version = "1.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FlagOpen";
    repo = "FlagEmbedding";
    tag = "v${version}";
    hash = "sha256-8W0tezt0MUIyQgeq8r10biGiR8ePmDgiJCBD7oudHuQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    transformers
    datasets
    accelerate
    sentence-transformers
    peft
    sentencepiece
    protobuf
    ir-datasets
  ];

  pythonImportsCheck = [
    "FlagEmbedding"
  ];

  meta = {
    description = "Retrieval and Retrieval-augmented LLMs";
    homepage = "http://www.bge-model.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "flag-embedding";
  };
}
