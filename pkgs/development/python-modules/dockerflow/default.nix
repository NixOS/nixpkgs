{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # optional dependencies
  asgiref,
  blinker,
  django,
  fastapi,
  flask,
  sanic,

  # tests
  django-redis,
  pytest-django,
  httpx,
  fakeredis,
  jsonschema,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  redis,
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "dockerflow";
  version = "2024.04.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "python-dockerflow";
    tag = version;
    hash = "sha256-5Ov605FyhX+n6vFks2sdtviGqkrgDIMXpcvgqR85jmQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    django = [ django ];
    flask = [
      blinker
      flask
    ];
    sanic = [ sanic ];
    fastapi = [
      asgiref
      fastapi
    ];
  };

  nativeCheckInputs = [
    fakeredis
    jsonschema
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    redis
    redisTestHook

    # django
    django-redis
    pytest-django

    # fastapi
    httpx
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # AssertionError: assert 'c7a05e2b-8a21-4255-a3ed-92cea1e74a62' is None
    "test_mozlog_without_correlation_id_middleware"
  ];

  disabledTestPaths = [
    # missing flask-redis dependency
    "tests/flask/test_flask.py"
    # missing sanic-redis dependency
    "tests/sanic/test_sanic.py"
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.django.settings
  '';

  pythonImportsCheck = [
    "dockerflow"
  ];

  meta = {
    changelog = "https://github.com/mozilla-services/python-dockerflow/releases/tag/${src.tag}";
    description = "Python package to implement tools and helpers for Mozilla Dockerflow";
    homepage = "https://github.com/mozilla-services/python-dockerflow";
    license = lib.licenses.mpl20;
  };
}
