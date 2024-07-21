{
  lib,
  accelerate,
  aiohttp,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  flask,
  numpy,
  pg8000,
  pillow,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  redis,
  requests,
  sentence-transformers,
  setuptools,
  sqlalchemy,
  sqlitedict,
  tenacity,
  tiktoken,
  torch,
  transformers,
  uvicorn,
  xxhash,
}:

buildPythonPackage rec {
  pname = "manifest-ml";
  version = "0.1.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "HazyResearch";
    repo = "manifest";
    rev = "refs/tags/v${version}";
    hash = "sha256-6m1XZOXzflBYyq9+PinbrW+zqvNGFN/aRDHH1b2Me5E=";
  };

  __darwinAllowLocalNetworking = true;

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pydantic
    redis
    requests
    aiohttp
    sqlitedict
    tenacity
    tiktoken
    xxhash
  ];

  passthru.optional-dependencies = {
    api = [
      accelerate
      # deepspeed
      # diffusers
      flask
      sentence-transformers
      torch
      transformers
    ];
    app = [
      fastapi
      uvicorn
    ];
    diffusers = [ pillow ];
    gcp = [
      pg8000
      # cloud-sql-python-connector
      sqlalchemy
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    # this file tries importing `deepspeed`, which is not yet packaged in nixpkgs
    "--ignore=tests/test_huggingface_api.py"
  ];

  disabledTests = [
    # Tests require DB access
    "test_init"
    "test_key_get_and_set"
    "test_get"
    # Tests require network access
    "test_abatch_run"
    "test_batch_run"
    "test_retry_handling"
    "test_run_chat"
    "test_run"
    "test_score_run"
    # Test is time-senstive
    "test_timing"
  ];

  pythonImportsCheck = [ "manifest" ];

  meta = with lib; {
    description = "Manifest for Prompting Foundation Models";
    homepage = "https://github.com/HazyResearch/manifest";
    changelog = "https://github.com/HazyResearch/manifest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
