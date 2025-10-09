{
  lib,
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
  sentencepiece,
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
  soundfile,
  soxr,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "mistral-common";
  version = "1.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-common";
    tag = "v${version}";
    hash = "sha256-HB6dsqiDSLhjyANk7ZT/cU98mjJamegAF0uKH8GfgM8=";
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
    sentencepiece
    tiktoken
    typing-extensions
  ];

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
  ];

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

  meta = {
    description = "Tools to help you work with Mistral models";
    homepage = "https://github.com/mistralai/mistral-common";
    changelog = "https://github.com/mistralai/mistral-common/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bgamari ];
  };
}
