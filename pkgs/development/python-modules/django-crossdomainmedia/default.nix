{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytestCheckHook,
  pytest-django,
  python,
}:

buildPythonPackage rec {
  pname = "django-crossdomainmedia";
  version = "0.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "stefanw";
    repo = "django-crossdomainmedia";
    # Release is not tagged yet
    # https://github.com/stefanw/django-crossdomainmedia/issues/1
    # rev = "refs/tags/v${version}";
    rev = "45af45a82e2630d99381758c7660fe9bdad06d2d";
    hash = "sha256-nwFUm+cxokZ38c5D77z15gIO/kg49oRACOl6+eGGEtQ=";
  };

  dependencies = [ django ];

  checkPhase = ''
    ${python.interpreter} manage.py test
  '';

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEBUG, but settings are not configured.
  # pythonImportsCheck = [ "crossdomainmedia" ];

  meta = {
    description = "Django application to retrieve user's IP address";
    homepage = "https://github.com/stefanw/django-crossdomainmedia";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
