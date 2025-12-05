{
  lib,
  buildPythonPackage,
  celery,
  cron-descriptor,
  django-timezone-field,
  django,
  fakeredis,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  python-crontab,
  python-dateutil,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "celery-redbeat";
  version = "2.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "django-celery-beat";
    tag = "v${version}";
    hash = "sha256-pakOpch5r2ug0UDSqEU34qr4Tz1/mkuFiHW+IOUuGcc=";
  };

  postPatch = ''
    # Hack the custom dependency resolution in setup.py to avoid pulling in pip
    substituteInPlace setup.py \
      --replace-fail "install_requires=reqs('default.txt') + reqs('runtime.txt')," "install_requires=[],"
  '';

  build-system = [ setuptools ];

  dependencies = [
    celery
    cron-descriptor
    django
    django-timezone-field
    python-crontab
    python-dateutil
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "django_celery_beat" ];

  # Tests require additional work
  doCheck = false;

  meta = with lib; {
    description = "Database-backed Periodic Tasks";
    homepage = "https://github.com/celery/django-celery-beat";
    changelog = "https://github.com/celery/django-celery-beat/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
