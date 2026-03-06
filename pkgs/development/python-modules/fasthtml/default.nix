{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  beautifulsoup4,
  fastcore,
  fastlite,
  httpx,
  itsdangerous,
  oauthlib,
  python-dateutil,
  python-multipart,
  starlette,
  uvicorn,

  # optional-dependencies
  ipython,
  lxml,
  monsterui ? null, # TODO: package
  pyjwt,
  pysymbol-llm ? null, # TODO: package

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fasthtml";
  version = "0.12.47";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fasthtml";
    tag = finalAttrs.version;
    hash = "sha256-dlG6pOVsd9RSmy/rgr7lUANRllND4tZDnsOecsI4bh8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    beautifulsoup4
    fastcore
    fastlite
    httpx
    itsdangerous
    oauthlib
    python-dateutil
    python-multipart
    starlette
    uvicorn
  ];

  optional-dependencies = {
    dev = [
      ipython
      lxml
      monsterui
      pyjwt
      pysymbol-llm
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/AnswerDotAI/fasthtml/issues/835
    "test_get_toaster_with_typehint"
  ];

  pythonImportsCheck = [
    "fasthtml"
  ];

  meta = {
    description = "The fastest way to create an HTML app";
    homepage = "https://github.com/AnswerDotAI/fasthtml";
    changelog = "https://github.com/AnswerDotAI/fasthtml/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
