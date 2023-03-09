{ lib
, aioredis
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jNfU5jT2xLgwVeVp8jXrQ6QQuUDwMOxf+hZ7VFsMFpM=";
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
