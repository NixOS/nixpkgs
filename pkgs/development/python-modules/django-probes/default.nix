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
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "painless-software";
    repo = "django-probes";
    rev = version;
    hash = "sha256-n3GI7fNxZkR0ZrI843q0EjkSfSK4LpUox09FFpigJY8=";
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
