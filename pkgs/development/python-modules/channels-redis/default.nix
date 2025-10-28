{
  lib,
  asgiref,
  buildPythonPackage,
  channels,
  cryptography,
  fetchFromGitHub,
  msgpack,
  setuptools,
  redis,
}:

buildPythonPackage rec {
  pname = "channels-redis";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "channels_redis";
    tag = version;
    hash = "sha256-zn313s1rzypSR5D3iE/05PeBQkx/Se/yaA3NS9BY//Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    redis
    asgiref
    channels
    msgpack
  ];

  optional-dependencies = {
    cryptography = [ cryptography ];
  };

  # Fails with : ConnectionRefusedError: [Errno 111] Connect call failed ('127.0.0.1', 6379)
  # (even with a local Redis instance running)
  doCheck = false;

  pythonImportsCheck = [ "channels_redis" ];

  meta = with lib; {
    description = "Redis-backed ASGI channel layer implementation";
    homepage = "https://github.com/django/channels_redis/";
    changelog = "https://github.com/django/channels_redis/blob/${src.tag}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
