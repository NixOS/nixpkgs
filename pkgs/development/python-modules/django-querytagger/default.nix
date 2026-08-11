{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-querytagger";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "django-querytagger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MtoxJ8Ci8UxHy2UBNMD7Z4fSWYnNpCZNxeYoAqkqSNA=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "django_querytagger"
  ];

  doCheck = false; # no tests

  __structuredAttrs = true;

  meta = {
    description = "Correlate SQL query logs in your database with your Django application and logs";
    homepage = "https://github.com/pretix/django-querytagger";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
