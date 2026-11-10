{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  django,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-widget-tweaks";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = "django-widget-tweaks";
    tag = version;
    hash = "sha256-ymjBuNGfndUwQdBU2xnc9CA51oOaEPA+RaAspJMKQ04=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = {
    description = "Tweak the form field rendering in templates, not in python-level form definitions";
    homepage = "https://github.com/django-commons/django-widget-tweaks";
    changelog = "https://github.com/django-commons/django-widget-tweaks/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxxk ];
  };
}
