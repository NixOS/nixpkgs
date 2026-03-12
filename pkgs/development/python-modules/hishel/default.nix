{
  lib,
  anysqlite,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  inline-snapshot,
  moto,
  msgpack,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  redis,
  redisTestHook,
  time-machine,
  trio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "hishel";
  version = "1.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "hishel";
    tag = version;
    hash = "sha256-VuUt1M0+ZztWoFZomAR5s1YQ4suIN3uEq54gLTjBLeY=";
  };

  postPatch = ''
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    httpx
    msgpack
    typing-extensions
  ];

  optional-dependencies = {
    redis = [ redis ];
    s3 = [ boto3 ];
    sqlite = [ anysqlite ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    inline-snapshot
    moto
    pytest-asyncio
    pytestCheckHook
    redisTestHook
    time-machine
    trio
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
    changelog = "https://github.com/karpetrosyan/hishel/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
