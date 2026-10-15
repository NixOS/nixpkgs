{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  django,
  funcy,
  redis,
  redisTestHook,
  six,
  pytestCheckHook,
  pytest-django,
  mock,
  dill,
  jinja2,
  before-after,
  net-tools,
  pkgs,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-cacheops";
  version = "7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Suor";
    repo = "django-cacheops";
    tag = finalAttrs.version;
    hash = "sha256-o0QPBfoYZzBPMjDQt8ck2Tkx3qInyfnN88buire0yc4=";
  };

  patches = [
    # Fixes failure with python3.14 pickle changes
    # https://github.com/Suor/django-cacheops/pull/511
    ./Support-Python-3.14-pickle-changes.patch
  ];

  pythonRelaxDeps = [ "funcy" ];

  build-system = [ setuptools ];

  dependencies = [
    django
    funcy
    redis
    six
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    mock
    dill
    jinja2
    before-after
    net-tools
    pkgs.valkey
    redisTestHook
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = {
    description = "Slick ORM cache with automatic granular event-driven invalidation for Django";
    homepage = "https://github.com/Suor/django-cacheops";
    changelog = "https://github.com/Suor/django-cacheops/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
})
