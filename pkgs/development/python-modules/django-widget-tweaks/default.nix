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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = "django-widget-tweaks";
    tag = version;
    hash = "sha256-lPWUSnp33KUFtmKDA4NucZw+DotUcZMa7V63krhyRBA=";
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
