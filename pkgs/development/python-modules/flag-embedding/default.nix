{
  lib,
  # Build system
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
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
    rev = "v${version}";
    hash = "sha256-8W0tezt0MUIyQgeq8r10biGiR8ePmDgiJCBD7oudHuQ=";
  };

  build-system = [
    setuptools
    wheel
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
    homepage = "https://github.com/FlagOpen/FlagEmbedding/tree/master";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "flag-embedding";
  };
}
