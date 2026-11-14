{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage {
  pname = "django-crossdomainmedia";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stefanw";
    repo = "django-crossdomainmedia";
    # Release is not tagged yet
    # https://github.com/stefanw/django-crossdomainmedia/issues/1
    # tag = "v${version}";
    rev = "45af45a82e2630d99381758c7660fe9bdad06d2d";
    hash = "sha256-nwFUm+cxokZ38c5D77z15gIO/kg49oRACOl6+eGGEtQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Django application to retrieve user's IP address";
    homepage = "https://github.com/stefanw/django-crossdomainmedia";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
