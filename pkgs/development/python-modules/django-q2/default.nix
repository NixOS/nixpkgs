{
  lib,
  arrow,
  blessed,
  bson,
  buildPythonPackage,
  croniter,
  django,
  django-picklefield,
  django-redis,
  fetchFromGitHub,
  hiredis,
  pkgs,
  poetry-core,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-q2";
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-q2";
    repo = "django-q2";
    rev = "refs/tags/v${version}";
    hash = "sha256-mp/IZkfT64xW42B1TEO6lSHxvLQbeH4td8vqZH7wUxM=";
  };

  postPatch = ''
    substituteInPlace django_q/tests/settings.py \
      --replace-fail "HiredisParser" "_HiredisParser"
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    arrow
    bson # required for mongodb but undocumented
    django
    django-picklefield
  ];

  nativeCheckInputs = [
    blessed
    croniter
    django-redis
    # pyredis refuses to load with hiredis<3.0.0
    (hiredis.overrideAttrs (
      new: old: {
        version = "3.1.0";
        src = old.src.override {
          rev = "refs/tags/v${new.version}";
          hash = "sha256-ID5OJdARd2N2GYEpcYOpxenpZlhWnWr5fAClAgqEgGg=";
        };
      }
    ))
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_q" ];

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  env = {
    MONGO_HOST = "127.0.0.1";
    REDIS_HOST = "127.0.0.1";
  };

  disabledTests = [
    # requires a running mongodb
    "test_mongo"
  ];

  disabledTestPaths = [
    "django_q/tests/test_commands.py"
  ];

  pytestFlagsArray = [ "-vv" ];

  meta = with lib; {
    description = "Multiprocessing distributed task queue for Django based on Django-Q";
    homepage = "https://github.com/django-q2/django-q2";
    changelog = "https://github.com/django-q2/django-q2/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
