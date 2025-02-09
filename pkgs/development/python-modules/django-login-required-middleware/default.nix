{ lib
, buildPythonPackage
, django
, djangorestframework
, fetchFromGitHub
, python
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-login-required-middleware";
  version = "0.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "CleitonDeLima";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WFQ/JvKh6gkUxPV27QBd2TzwFS8hfQGmcTInTnmh6iA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

  checkInputs = [
    djangorestframework
  ];

  pythonImportsCheck = [
    "login_required"
  ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings tests.settings
  '';

  meta = with lib; {
    description = "Requires login to all requests through middleware in Django";
    homepage = "https://github.com/CleitonDeLima/django-login-required-middleware";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
