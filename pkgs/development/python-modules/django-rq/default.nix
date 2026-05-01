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
  pytest-django,
  pytestCheckHook,
  pyyaml,
  redisTestHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-rq";
  version = "4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "django-rq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c/elbEi+m3WVGl8137ct1PsxRM397uZNPy9X54b8fmg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    redis
    rq
  ];

  optional-dependencies = {
    prometheus = [ prometheus-client ];
  };

  # redis hook does not support darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
    pyyaml
    redisTestHook
  ]
  ++ lib.concatAttrValues finalAttrs.finalPackage.optional-dependencies;

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  disabledTests = [
    # ValueError: Job ID must only contain letters, numbers, underscores and dashes
    "test_scheduled_jobs"
  ];

  meta = {
    description = "Simple app that provides django integration for RQ (Redis Queue)";
    homepage = "https://github.com/rq/django-rq";
    changelog = "https://github.com/rq/django-rq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
