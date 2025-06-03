{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  django,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-widget-tweaks";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-widget-tweaks";
    tag = version;
    hash = "sha256-ymjBuNGfndUwQdBU2xnc9CA51oOaEPA+RaAspJMKQ04=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with lib; {
    description = "Tweak the form field rendering in templates, not in python-level form definitions";
    homepage = "https://github.com/jazzband/django-widget-tweaks";
    changelog = "https://github.com/jazzband/django-widget-tweaks/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ maxxk ];
  };
}
