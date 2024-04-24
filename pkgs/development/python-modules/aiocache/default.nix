{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pythonOlder
, redis
, setuptools
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.12.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiocache";
    rev = "refs/tags/v${version}";
    hash = "sha256-yvXDNJL8uxReaU81klVWudJwh1hmvg5GeeILcNpm/YA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru.optional-dependencies = {
    redis = [
      redis
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
