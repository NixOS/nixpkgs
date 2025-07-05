{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  python,
  django-guardian,
}:

buildPythonPackage rec {
  pname = "django-fsm";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viewflow";
    repo = "django-fsm";
    tag = version;
    hash = "sha256-woN0F4hTaPk8HTGNT6zQlZDJ9SCVRut9maKSlDmalUE=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  checkInputs = [ django-guardian ];

  checkPhase = ''
    ${python.interpreter} tests/manage.py test
  '';

  pythonImportsCheck = [ "django_fsm" ];

  meta = {
    description = "Django friendly finite state machine support";
    homepage = "https://github.com/viewflow/django-fsm";
    license = lib.licenses.mit;
    knownVulnerabilities = [ "Package is marked as discontinued upstream." ];
    maintainers = [ lib.maintainers.onny ];
  };
}
