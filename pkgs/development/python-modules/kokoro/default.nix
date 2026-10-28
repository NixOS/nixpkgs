{
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  hatchling,
  huggingface-hub,
  lib,
  loguru,
  misaki,
  numpy,
  pytestCheckHook,
  torch,
  transformers,
}:

buildPythonPackage {
  pname = "kokoro";
  version = "0-unstable-2025-06-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hexgrad";
    repo = "kokoro";
    rev = "2668b2e279d0f94977995230e523b0183763f30e";
    hash = "sha256-slXbn0W1632Hak6Z0ofF0gyavxRLoxS4fyPQLHSapjA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    huggingface-hub
    loguru
    misaki
    numpy
    torch
    transformers
  ]
  ++ misaki.optional-dependencies.en; # kokoro depends on misaki[en]

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # See https://github.com/hexgrad/kokoro/issues/225
    "test_different_window_sizes"
    "test_stft_reconstruction"
  ];

  pythonImportsCheck = [
    "kokoro"
  ];

  meta = {
    description = "Open-weight TTS model with 82 million parameters";
    homepage = "https://github.com/hexgrad/kokoro";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
