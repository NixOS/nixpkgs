{ lib
, aioredis
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/ruB8/5/oWGlTldOXkgdsPU+mQlXOL1qRcikElEHYNQ=";
  };

  passthru.optional-dependencies = {
    redis = [
      aioredis
    ];
    msgpack = [
      msgpack
    ];
  };

  # aiomcache would be required but last release was in 2017
  doCheck = false;

  pythonImportsCheck = [
    "aiocache"
  ];

  meta = with lib; {
    description = "Python API Rate Limit Decorator";
    homepage = "https://github.com/aio-libs/aiocache";
    changelog = "https://github.com/aio-libs/aiocache/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
