{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  celery,
  django,
  fetchFromGitHub,
  importlib-metadata,
  python,
  requests,
  setuptools,
  structlog,
}:

buildPythonPackage rec {
  pname = "django-google-analytics-app";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praekeltfoundation";
    repo = "django-google-analytics";
    tag = version;
    hash = "sha256-0KLfGZY8qq5JGb+LJXpQRS76+qXtrf/hv6QLenm+BhQ=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "celery"
    "django"
  ];

  dependencies = [
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

  pythonImportsCheck = [ "google_analytics" ];

  meta = {
    description = "Django Google Analytics brings the power of server side/non-js Google Analytics to your Django projects";
    homepage = "https://github.com/praekeltfoundation/django-google-analytics/";
    changelog = "https://github.com/praekeltfoundation/django-google-analytics/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
