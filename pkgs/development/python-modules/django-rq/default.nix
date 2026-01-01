{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  redis,
  rq,
  prometheus-client,
  sentry-sdk,
<<<<<<< HEAD
  pytest-django,
  pytestCheckHook,
  pyyaml,
=======
  psycopg,
  pytest-django,
  pytestCheckHook,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "django-rq";
<<<<<<< HEAD
  version = "3.2.2";
=======
  version = "3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "django-rq";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vKvEFySTgIWqe6RYnl3POtjCEbCJZsRKL2KcRs9bv30=";
=======
    hash = "sha256-TnOKgw52ykKcR0gHXcdYfv77js7I63PE1F3POdwJgvc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  doCheck = false; # require redis-server

  meta = with lib; {
    description = "Simple app that provides django integration for RQ (Redis Queue)";
    homepage = "https://github.com/rq/django-rq";
    changelog = "https://github.com/rq/django-rq/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
