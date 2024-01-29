{ lib
, anysqlite
, buildPythonPackage
, fetchFromGitHub
, hatch-fancy-pypi-readme
, hatchling
, httpx
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pyyaml
, redis
, trio
}:

buildPythonPackage rec {
  pname = "hishel";
  version = "0.0.21";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "karpetrosyan";
    repo = "hishel";
    rev = "refs/tags/${version}";
    hash = "sha256-okNNYEq97qb2OoP3N+MvG7o3YADfd6LxP8EaNuWDGOM=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
  ];

  passthru.optional-dependencies = {
    redis = [
      redis
    ];
    sqlite = [
      anysqlite
    ];
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    trio
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "hishel"
  ];

  disabledTests = [
    # Tests require a running Redis instance
    "test_redis"
  ];

  meta = with lib; {
    description = "HTTP Cache implementation for HTTPX and HTTP Core";
    homepage = "https://github.com/karpetrosyan/hishel";
    changelog = "https://github.com/karpetrosyan/hishel/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

