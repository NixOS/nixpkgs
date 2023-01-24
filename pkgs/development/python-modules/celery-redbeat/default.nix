{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, celery
, redis
, tenacity
, pytestCheckHook
, fakeredis
, mock
}:

buildPythonPackage rec {
  pname = "celery-redbeat";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "redbeat";
    rev = "v${version}";
    hash = "sha256-pu4umhfNFZ30bQu5PcT2LYN4WGzFj4p4/qHm3pVIV+c=";
  };

  propagatedBuildInputs = [
    python-dateutil
    celery
    redis
    tenacity
  ];

  nativeCheckInputs = [
    pytestCheckHook
    fakeredis
    mock
  ];

  pythonImportsCheck = [ "redbeat" ];

  meta = with lib; {
    description = "Database-backed Periodic Tasks";
    homepage = "https://github.com/celery/django-celery-beat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
