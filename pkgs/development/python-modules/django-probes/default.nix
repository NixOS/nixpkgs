{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pytestCheckHook,
  pytest-django,
}:
buildPythonPackage rec {
  pname = "django-probes";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "painless-software";
    repo = "django-probes";
    rev = version;
    hash = "sha256-opto5AAUPhEsWbYh7nItUw7qNoUfOFFZ7tw5agWGBSg=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "django_probes"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  meta = {
    description = "Django app to run database liveness probe in a Kubernetes project";
    homepage = "https://github.com/painless-software/django-probes";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      LorenzBischof
      jcollie
    ];
  };
}
