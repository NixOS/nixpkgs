{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  django,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-widget-tweaks";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/3UIsg75X3R9YGv9cEcoPw3IN2vkhUb+HCy68813d2E=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ django ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with lib; {
    description = "Tweak the form field rendering in templates, not in python-level form definitions";
    homepage = "https://github.com/jazzband/django-widget-tweaks";
    changelog = "https://github.com/jazzband/django-widget-tweaks/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ maxxk ];
  };
}
