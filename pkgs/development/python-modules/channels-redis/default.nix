{
  lib,
  aioredis,
  asgiref,
  buildPythonPackage,
  channels,
  cryptography,
  fetchFromGitHub,
  hiredis,
  msgpack,
  pythonOlder,
  redis,
}:

buildPythonPackage rec {
  pname = "channels-redis";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = "channels_redis";
    rev = "refs/tags/${version}";
    hash = "sha256-Eid9aWlLNnqr3WAnsLe+Pz9gsugCsdDKi0+nFNF02CI=";
  };

  buildInputs = [
    hiredis
    redis
  ];

  propagatedBuildInputs = [
    aioredis
    asgiref
    channels
    msgpack
  ];

  passthru.optional-dependencies = {
    cryptography = [ cryptography ];
  };

  # Fails with : ConnectionRefusedError: [Errno 111] Connect call failed ('127.0.0.1', 6379)
  # (even with a local Redis instance running)
  doCheck = false;

  pythonImportsCheck = [ "channels_redis" ];

  meta = with lib; {
    description = "Redis-backed ASGI channel layer implementation";
    homepage = "https://github.com/django/channels_redis/";
    changelog = "https://github.com/django/channels_redis/blob/${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
