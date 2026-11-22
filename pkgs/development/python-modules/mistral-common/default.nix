{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jsonschema,
  numpy,
  pillow,
  pydantic,
  pydantic-extra-types,
  requests,
  tiktoken,
  typing-extensions,

  # optional-dependencies
  click,
  fastapi,
  huggingface-hub,
  jinja2,
  llguidance,
  opencv-python-headless,
  pydantic-settings,
  pytest-xdist,
  pytestCheckHook,
  sentencepiece,
  soundfile,
  soxr,
  uvloop,

  # tests
  openai,
  pycountry,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistral-common";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-common";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BUX9ZkitJnqaFipMozFPOYvxhuxj9eOmemYyrYUD+Hg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    jsonschema
    numpy
    pillow
    pydantic
    pydantic-extra-types
    requests
    tiktoken
    # Dropped from pyproject.toml but still imported by mistral_common.guidance
    typing-extensions
  ];

  optional-dependencies = lib.fix (self: {
    opencv = [
      opencv-python-headless
    ];
    sentencepiece = [
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
    guidance = [
      jinja2
      llguidance
    ];
    hf-hub = [
      huggingface-hub
    ];
    server = [
      click
      fastapi
      pydantic-settings
      uvloop
    ]
    ++ fastapi.optional-dependencies.standard;
  });

  pythonImportsCheck = [ "mistral_common" ];

  nativeCheckInputs = [
    openai
    pycountry
    pytest-xdist
    pytestCheckHook
    uvicorn
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # AssertionError: assert 0.028677442591911916 < 0.005
    "test_audio_base64"
  ];

  meta = {
    description = "Tools to help you work with Mistral models";
    homepage = "https://github.com/mistralai/mistral-common";
    changelog = "https://github.com/mistralai/mistral-common/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bgamari ];
  };
})
