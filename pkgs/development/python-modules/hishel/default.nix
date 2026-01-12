{
  lib,
  anysqlite,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  moto,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  redis,
  trio,
}:

buildPythonPackage rec {
  pname = "hishel";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "hishel";
    tag = version;
    hash = "sha256-3dcXj9MPPtHBzafdccrOeh+Wrn9hulDA8L3itOe8ZXw=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [ httpx ];

  optional-dependencies = {
    redis = [ redis ];
    s3 = [ boto3 ];
    sqlite = [ anysqlite ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    moto
    pytest-asyncio
    pytestCheckHook
    trio
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "hishel" ];

  disabledTests = [
    # Tests require a running Redis instance
    "test_redis"
  ];

  disabledTestPaths = [
    # ImportError: cannot import name 'mock_s3' from 'moto'
    "tests/_async/test_storages.py"
    "tests/_sync/test_storages.py"
  ];

  meta = {
    description = "HTTP Cache implementation for HTTPX and HTTP Core";
    homepage = "https://github.com/karpetrosyan/hishel";
    changelog = "https://github.com/karpetrosyan/hishel/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
