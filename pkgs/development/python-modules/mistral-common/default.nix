{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  wheel,
  build,

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
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-common";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DejbLY2i6Hp1J+spxMut5RKugj7rDyrZmp6v+5wqyWY=";
  };

  build-system = [
    setuptools
    wheel
    build
  ];

  dependencies = [
    jsonschema
    numpy
    pillow
    pydantic
    pydantic-extra-types
    requests
    tiktoken
    typing-extensions
  ];

  optional-dependencies =
    let
      self = finalAttrs.finalPackage.optional-dependencies;
    in
    {
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
      all =
        self.opencv
        ++ self.sentencepiece
        ++ self.audio
        ++ self.image
        ++ self.guidance
        ++ self.hf-hub
        ++ self.server;
    };

  pythonImportsCheck = [ "mistral_common" ];

  nativeCheckInputs = [
    openai
    pycountry
    pytestCheckHook
    uvicorn
  ]
  ++ finalAttrs.finalPackage.optional-dependencies.all;

  disabledTests = [
    # AssertionError, Extra items in the right set
    "test_openai_chat_fields"
  ];

  meta = {
    description = "Tools to help you work with Mistral models";
    homepage = "https://github.com/mistralai/mistral-common";
    changelog = "https://github.com/mistralai/mistral-common/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bgamari ];
  };
})
