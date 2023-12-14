{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, pytest-django
, python
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-simple-history";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-simple-history";
    rev = "refs/tags/${version}";
    hash = "sha256-XY6YNajwX5z3AXkYYGFtrURDqxub9EQwu52jQ7CZwrI=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  pythonImportsCheck = [
    "simple_history"
  ];

  meta = with lib; {
    description = "django-simple-history stores Django model state on every create/update/delete";
    homepage = "https://github.com/jazzband/django-simple-history/";
    changelog = "https://github.com/jazzband/django-simple-history/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
