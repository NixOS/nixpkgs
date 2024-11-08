{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      # celery 5.3.0 support
      url = "https://github.com/sibson/redbeat/commit/4240e17172a4d9d2744d5c4da3cfca0e0a024e2e.patch";
      hash = "sha256-quEfSFhv0sIpsKHX1CpFhbMC8LYXA8NASWYU8MMYPSk=";
    })
  ];

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
