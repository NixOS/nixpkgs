{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  celery,
  cron-descriptor,
  django-timezone-field,
  python-crontab,
  tzdata,

  # tests
  ephem,
  pytest-django,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-celery-beat";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "django-celery-beat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UGKMSXB+Hg865sAk5ePc/noO3eNTr7b3pp7tvNvn1T8=";
  };

  # https://github.com/celery/django-celery-beat/pull/1009
  patches = [
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/dc11bdfa06858409da01f2d407bb68486870a559.patch";
      hash = "sha256-aK8u2CfmNYFwE9CQvKjnwywVcw8MQfXvev7JYU9kz4E=";
    })
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/ddcbe8bf2c970a82e87f50c0e9c232b0ae951a85.patch";
      hash = "sha256-uw3l6CA0lnbF1HnNeSgZ91l1ujkB4V3831Yj+L4i+L0=";
    })
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/088355dc6531bfffc19272c9de55f4d18606634e.patch";
      hash = "sha256-6pamaLcHbNUGJMw6nCWeY/C1O58choDbJ1j/4SqDPx4=";
    })
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/273e2f23edee26404a1691320a69dee280f9639b.patch";
      hash = "sha256-8wZrDi9GDIF+w5ZZDssJGLG3UyE45xqld95nnG3SV0A=";
    })
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/69f4a231f30df9ff028f8fc0f67cb115e5d53246.patch";
      hash = "sha256-74p2XxB9ssWpVokY8XVUjkyyE4+/2lijDYZcZSu9ms0=";
    })
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/4b8246a44a69e79d7648a9f4658abd8b7937b2b8.patch";
      hash = "sha256-c1ZJHgnxvOoEWAc9oRkcCLRG7sLLsSER/Dq0H8TIOYU=";
    })
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/17dd67625f99a0e6dbe7fb779f61f336e7af1730.patch";
      hash = "sha256-w+MynocR80jUARgvuk5cUIdzmdAYGglvrNXph/8XdBE=";
    })
    (fetchpatch {
      url = "https://github.com/celery/django-celery-beat/commit/03018882f088be83e1c78b4ca657b960b3080081.patch";
      hash = "sha256-YE121p2aGqoj9mRFSQu+oi+8xaz0QE+CsJHdBB7xwUM=";
    })
  ];

  pythonRelaxDeps = [ "django" ];

  build-system = [ setuptools ];

  dependencies = [
    celery
    cron-descriptor
    django-timezone-field
    python-crontab
    tzdata
  ];

  nativeCheckInputs = [
    ephem
    pytest-django
    pytest-timeout
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Connection error
    "t/unit/test_schedulers.py"
  ];

  pythonImportsCheck = [ "django_celery_beat" ];

  meta = {
    description = "Celery Periodic Tasks backed by the Django ORM";
    homepage = "https://github.com/celery/django-celery-beat";
    changelog = "https://github.com/celery/django-celery-beat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
})
