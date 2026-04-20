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

buildPythonPackage rec {
  pname = "django-health-check";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "django-health-check";
    tag = version;
    hash = "sha256-XHautU7asnlm5Pxddf9+UD20v75rbc9Uo7hLjDYt/SU=";
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
  ];

  pythonImportsCheck = [ "health_check" ];

  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
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
    changelog = "https://github.com/codingjoe/django-health-check/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      onny
      dav-wolff
    ];
  };
}
