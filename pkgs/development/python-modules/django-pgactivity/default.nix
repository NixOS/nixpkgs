{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  psycopg,
}:

buildPythonPackage rec {
  pname = "django-pgactivity";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pgactivity";
    tag = version;
    hash = "sha256-PDJJf0PI5aqFn1HODv6wRSgTCr9ajfpPSDCB8twrFcQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    psycopg
  ];

  pythonImportsCheck = [ "pgactivity" ];

  meta = {
    description = "View, filter, and kill Postgres queries";
    homepage = "https://github.com/AmbitionEng/django-pgactivity";
    changelog = "https://github.com/AmbitionEng/django-pgactivity/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
