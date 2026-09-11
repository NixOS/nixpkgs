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
  version = "4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "django-rq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sd1qPPjr4MmS/74OIlmfNCVAJIVXLFC71cwn18n/wNk=";
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
