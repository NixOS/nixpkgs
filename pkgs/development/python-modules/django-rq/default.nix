{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  redis,
  rq,
  prometheus-client,
  sentry-sdk,
  pytest-django,
  pytestCheckHook,
  pyyaml,
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "django-rq";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "django-rq";
    tag = "v${version}";
    hash = "sha256-vKvEFySTgIWqe6RYnl3POtjCEbCJZsRKL2KcRs9bv30=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    redis
    rq
  ];

  optional-dependencies = {
    prometheus = [ prometheus-client ];
    sentry = [ sentry-sdk ];
  };

  pythonImportsCheck = [ "django_rq" ];

  # redis hook does not support darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
    pyyaml
    redisTestHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  meta = {
    description = "Simple app that provides django integration for RQ (Redis Queue)";
    homepage = "https://github.com/rq/django-rq";
    changelog = "https://github.com/rq/django-rq/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
