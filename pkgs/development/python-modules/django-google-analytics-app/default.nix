{ lib
, beautifulsoup4
, buildPythonPackage
, celery
, django
, fetchFromGitHub
, importlib-metadata
, python
, pythonOlder
, requests
, structlog
}:

buildPythonPackage rec {
  pname = "django-google-analytics-app";
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "praekeltfoundation";
    repo = "django-google-analytics";
    rev = "refs/tags/${version}";
    hash = "sha256-0KLfGZY8qq5JGb+LJXpQRS76+qXtrf/hv6QLenm+BhQ=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    celery
    django
    importlib-metadata
    requests
    structlog
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django check --settings=test_settings
    runHook postCheck
  '';

  pythonImportsCheck = [
    "google_analytics"
  ];

  meta = with lib; {
    description = "Django Google Analytics brings the power of server side/non-js Google Analytics to your Django projects";
    homepage = "https://github.com/praekeltfoundation/django-google-analytics/";
    changelog = "https://github.com/praekeltfoundation/django-google-analytics/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
