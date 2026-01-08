{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  python-dateutil,
  pytest-django,
  pytestCheckHook,
  pytest-cov,
  pytest-sugar,
  setuptools-scm,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-recurrence";
  version = "1.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-recurrence";
    tag = version;
    hash = "sha256-Ytf4fFTVFIQ+6IBhwRMtCkonP0POivv4TrYok37nghA=";
  };

  disabled = pythonOlder "3.7";

  dependencies = [
    django
    python-dateutil
  ];

  build-system = [ setuptools-scm ];
  doCheck = true;
  pythonImportsCheck = [ "recurrence" ];
  nativeCheckInputs = [
    pytest-django
    pytest-cov
    pytest-sugar
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Utility for working with recurring dates in Django.";
    homepage = "https://github.com/jazzband/django-recurrence";
    changelog = "https://github.com/jazzband/django-recurrence/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kurogeek ];
  };
}
