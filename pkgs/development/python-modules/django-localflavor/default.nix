{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # bring your own
  django,

  # propagates
  python-stdnum,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-localflavor";
  version = "4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "django";
    repo = "django-localflavor";
    rev = "refs/tags/${version}";
    hash = "sha256-UWp3ei1VlEsEfjbJIE+MpffSzYF4X1HEQw+z+5kZoP0=";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [ python-stdnum ];

  pythonImportsCheck = [
    # samples
    "localflavor.ar"
    "localflavor.de"
    "localflavor.fr"
    "localflavor.my"
    "localflavor.nl"
    "localflavor.us"
    "localflavor.za"
  ];

  checkInputs = [
    pytest-django
    pytestCheckHook
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    description = "Country-specific Django helpers";
    homepage = "https://github.com/django/django-localflavor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
