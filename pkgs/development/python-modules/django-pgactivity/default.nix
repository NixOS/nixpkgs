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
<<<<<<< HEAD
  version = "1.8.0";
=======
  version = "1.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pgactivity";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-e+PodpFsGxx4SE6zQD2qVDAXx44xeIdsBO7YsdbSjiU=";
=======
    hash = "sha256-PDJJf0PI5aqFn1HODv6wRSgTCr9ajfpPSDCB8twrFcQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
