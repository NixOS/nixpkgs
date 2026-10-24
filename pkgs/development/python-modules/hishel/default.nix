{
  lib,
  anyio,
  anysqlite,
  buildPythonPackage,
  fetchFromGitHub,
  fastapi,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  httpx2,
  inline-snapshot,
  msgpack,
  pytest-asyncio,
  pytestCheckHook,
  redis,
  redisTestHook,
  requests,
  fakeredis,
  time-machine,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "hishel";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "hishel";
    tag = finalAttrs.version;
    hash = "sha256-55hoTxa8rQB4ZPQQ7dwTk0t3juUU2QJ0bjieXj9+MM4=";
  };

  postPatch = ''
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    msgpack
    typing-extensions
  ];

  optional-dependencies = {
    async = [
      anyio
      anysqlite
    ];
    requests = [ requests ];
    httpx = [ httpx ];
    httpx2 = [
      anyio
      anysqlite
      httpx2
    ];
    fastapi = [ fastapi ];
    redis = [ redis ];
  };

  nativeCheckInputs = [
    inline-snapshot
    pytest-asyncio
    pytestCheckHook
    redisTestHook
    fakeredis
    time-machine
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    # network access
    "test_encoded_content_caching"
    "test_simple_caching"
    "test_simple_caching_ignoring_spec"
  ];

  pythonImportsCheck = [ "hishel" ];

  meta = {
    description = "HTTP Cache implementation for HTTPX and HTTP Core";
    homepage = "https://github.com/karpetrosyan/hishel";
    changelog = "https://github.com/karpetrosyan/hishel/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
