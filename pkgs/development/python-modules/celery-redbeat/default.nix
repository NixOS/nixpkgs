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
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Database-backed Periodic Tasks";
    homepage = "https://github.com/celery/django-celery-beat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
