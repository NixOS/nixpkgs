{
  lib,
  stdenv,
  buildPythonPackage,
  celery,
  fetchFromGitHub,
  flit-core,
  flit-scm,
  pytest-cov-stub,
  pytest-django,
  pytestCheckHook,
  redis,
  psutil,
  dnspython,
  pytest-asyncio,
  libredirect,
  confluent-kafka,
  aio-pika,
  httpx,
  feedparser,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-health-check";
  version = "4.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "django-health-check";
    tag = finalAttrs.version;
    hash = "sha256-brC/gMqxo6BsfMA+4u9alOtIH4js4EgdExT1LL0QXxU=";
  };

  build-system = [
    flit-core
    flit-scm
  ];

  dependencies = [
    dnspython
  ];

  optional-dependencies = {
    psutil = [ psutil ];
    celery = [ celery ];
    kafka = [ confluent-kafka ];
    rabbitmq = [ aio-pika ];
    redis = [ redis ];
    rss = [
      httpx
      feedparser
    ];
    atlassian = [ httpx ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-django
    pytestCheckHook
    psutil
    pytest-asyncio
    libredirect.hook
  ];

  disabledTests = [
    # require online DNS resolution
    "test_run_check__dns_working"
    "test_check_status__nonexistent_hostname"
    "test_check_status__no_answer"
  ]
  ++ lib.optionals stdenv.isDarwin [
    # sensors_temperatures is not available on darwin: https://psutil.readthedocs.io/stable/index.html#psutil.sensors_temperatures
    "TestTemperature"
    # some metrics aren't available on darwin: https://psutil.readthedocs.io/stable/index.html#psutil.virtual_memory
    "TestMemory"
    # live_server not working on darwin
    "TestHealthCheckCommand"
  ];

  pythonImportsCheck = [ "health_check" ];

  preCheck = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/resolv.conf=$(realpath resolv.conf)
  '';

  preInstallCheck = ''
    export PYTHONPATH=$PWD:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE=tests.testapp.settings
  '';

  meta = {
    description = "Pluggable app that runs a full check on the deployment";
    homepage = "https://github.com/codingjoe/django-health-check";
    changelog = "https://github.com/codingjoe/django-health-check/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      onny
      dav-wolff
    ];
  };
})
