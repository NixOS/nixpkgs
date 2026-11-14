{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
  django,
  pytest-unmagic,
}:

buildPythonPackage rec {
  pname = "django-cte";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimagi";
    repo = "django-cte";
    tag = "v${version}";
    hash = "sha256-bbZfocnYlVWE3Q+VPGWGlgAbVlkdEKpJhpge7YE9M60=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-unmagic
  ];

  pythonImportsCheck = [ "django_cte" ];

  meta = {
    description = "Common Table Expressions (CTE) for Django";
    homepage = "https://github.com/dimagi/django-cte";
    changelog = "https://github.com/dimagi/django-cte/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
