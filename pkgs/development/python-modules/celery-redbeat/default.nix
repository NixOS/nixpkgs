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
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "redbeat";
    tag = "v${version}";
    hash = "sha256-lAEbhRTp0jYrCgHaTvPrl+lW1NRezmmTqAnUmLdpVwY=";
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
