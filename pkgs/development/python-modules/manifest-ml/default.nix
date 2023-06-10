{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, numpy
, pydantic
, redis
, requests
, aiohttp
, sqlitedict
, tenacity
, tiktoken
, xxhash
, # optional dependencies
  accelerate
, flask
, sentence-transformers
, torch
, transformers
, fastapi
, uvicorn
, pillow
, pg8000
, sqlalchemy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "manifest-ml";
  version = "0.1.8";
  format = "setuptools";

  disalbed = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "HazyResearch";
    repo = "manifest";
    rev = "refs/tags/v${version}";
    hash = "sha256-d34TIZYDB8EDEIZUH5mDzfDHzFT290DwjPLJkNneklc=";
  };

  propagatedBuildInputs = [
    numpy
    pydantic
    redis
    requests
    aiohttp
    sqlitedict
    tenacity
    tiktoken
    xxhash
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

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
    diffusers = [
      pillow
    ];
    gcp = [
      pg8000
      # cloud-sql-python-connector
      sqlalchemy
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    # this file tries importing `deepspeed`, which is not yet packaged in nixpkgs
    "--ignore=tests/test_huggingface_api.py"
  ];

  disabledTests = [
    # these tests have db access
    "test_init"
    "test_key_get_and_set"
    "test_get"
    # this test has network access
    "test_retry_handling"
  ];

  meta = with lib; {
    description = "Manifest for Prompting Foundation Models";
    homepage = "https://github.com/HazyResearch/manifest";
    changelog = "https://github.com/HazyResearch/manifest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
