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
  version = "2.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "redbeat";
    tag = "v${version}";
    hash = "sha256-nUVioETVIAjLPOmhBSf+bOUsYuV1C1VGwHz5KjbIjHc=";
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
