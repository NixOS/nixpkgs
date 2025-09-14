{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  celery,
  redis,
  tenacity,
  pytestCheckHook,
  pytz,
  fakeredis,
  mock,
}:

buildPythonPackage rec {
  pname = "celery-redbeat";
  version = "2.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "redbeat";
    tag = "v${version}";
    hash = "sha256-bptEAOVxuwj9Y7LyBhtMU22Z1uCiJ4O4BZT2ytqQI80=";
  };

  propagatedBuildInputs = [
    celery
    python-dateutil
    redis
    tenacity
  ];

  nativeCheckInputs = [
    fakeredis
    mock
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "redbeat" ];

  meta = {
    description = "Database-backed Periodic Tasks";
    homepage = "https://github.com/celery/django-celery-beat";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
