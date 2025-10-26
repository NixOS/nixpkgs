{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  onnxruntime,
  sentencepiece,
  torch,
  tqdm,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "gliner";
  version = "0.2.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "urchade";
    repo = "GLiNER";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4IPT8mW3I998T9W/qDJRZifZYRJUyjeu54gtsOnFNWY=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "transformers"
  ];
  dependencies = [
    huggingface-hub
    onnxruntime
    sentencepiece
    torch
    tqdm
    transformers
  ];

  pythonImportsCheck = [ "gliner" ];

  # All tests require internet
  doCheck = false;

  meta = {
    description = "Generalist and Lightweight Model for Named Entity Recognition";
    homepage = "https://github.com/urchade/GLiNER";
    changelog = "https://github.com/urchade/GLiNER/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
      # Attempt to use DefaultLogger but none has been registered.
      "aarch64-linux"
    ];
  };
})
