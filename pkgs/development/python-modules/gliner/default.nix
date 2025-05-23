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

buildPythonPackage rec {
  pname = "gliner";
  version = "0.2.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "urchade";
    repo = "GLiNER";
    tag = "v${version}";
    hash = "sha256-aWBDnaiq9Z30YT4sszEVk1WAyU4aH8SFD6ESOBkT2ds=";
  };

  build-system = [
    setuptools
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
    changelog = "https://github.com/urchade/GLiNER/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
      # Attempt to use DefaultLogger but none has been registered.
      "aarch64-linux"
    ];
  };
}
