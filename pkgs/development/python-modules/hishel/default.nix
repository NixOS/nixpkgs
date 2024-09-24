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
  pythonOlder,
  pyyaml,
  redis,
  trio,
}:

buildPythonPackage rec {
  pname = "hishel";
  version = "0.0.31";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "hishel";
    rev = "refs/tags/${version}";
    hash = "sha256-mJPvzGmu0veFlG7jlWdf919qOp3KfGv6SPRcFVFjhnc=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [ httpx ];

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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

  meta = with lib; {
    description = "HTTP Cache implementation for HTTPX and HTTP Core";
    homepage = "https://github.com/karpetrosyan/hishel";
    changelog = "https://github.com/karpetrosyan/hishel/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
