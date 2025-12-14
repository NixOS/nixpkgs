{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jsonschema,
  numpy,
  opencv-python-headless,
  pillow,
  pydantic,
  pydantic-extra-types,
  requests,
  tiktoken,
  typing-extensions,

  # tests
  click,
  fastapi,
  huggingface-hub,
  openai,
  pycountry,
  pydantic-settings,
  pytestCheckHook,
  sentencepiece,
  soundfile,
  soxr,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "mistral-common";
  version = "1.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-common";
    tag = "v${version}";
    hash = "sha256-k0En4QHQGzuUm6kdAyPQhbCrmwX3ay/xJ/ktCxiZIBk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    numpy
    opencv-python-headless
    pillow
    pydantic
    pydantic-extra-types
    requests
    tiktoken
    typing-extensions
  ];

  optional-dependencies = lib.fix (self: {
    opencv = [
      opencv-python-headless
    ];
    # Broken on Darwin. See https://github.com/NixOS/nixpkgs/issues/466092
    sentencepiece = lib.optionals (!stdenv.hostPlatform.isDarwin) [
      sentencepiece
    ];
    soundfile = [
      soundfile
    ];
    soxr = [
      soxr
    ];
    audio = self.soundfile ++ self.soxr;
    image = self.opencv;
    hf-hub = [
      huggingface-hub
    ];
    server = [
      click
      fastapi
      pydantic-settings
    ]
    ++ fastapi.optional-dependencies.standard;
  });

  pythonImportsCheck = [ "mistral_common" ];

  nativeCheckInputs = [
    click
    fastapi
    huggingface-hub
    openai
    pycountry
    pydantic-settings
    pytestCheckHook
    soundfile
    soxr
    uvicorn
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # Require internet
    "test_download_gated_image"
    "test_image_encoder_formats"
    "test_image_processing"

    # AssertionError: Regex pattern did not match.
    "test_from_url"

    # AssertionError, Extra items in the right set
    "test_openai_chat_fields"
  ];

  # Requires sentencepiece which segfaults when initialized on Darwin
  # See https://github.com/NixOS/nixpkgs/issues/466092
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/experimental/test_app.py"
    "tests/experimental/test_tools.py"
    "tests/test_fim_tokenizer.py"
    "tests/test_integration_samples.py"
    "tests/test_mistral_tokenizer.py"
    "tests/test_tokenize_v1.py"
    "tests/test_tokenize_v2.py"
    "tests/test_tokenize_v3.py"
    "tests/test_tokenizer_v7.py"
  ];

  meta = {
    description = "Tools to help you work with Mistral models";
    homepage = "https://github.com/mistralai/mistral-common";
    changelog = "https://github.com/mistralai/mistral-common/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bgamari ];
  };
}
