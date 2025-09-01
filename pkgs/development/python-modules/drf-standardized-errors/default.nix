{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  flit-core,
  django,
  djangorestframework,
  drf-spectacular,
  inflection,
  pytestCheckHook,
  pytest-django,
  django-filter,
}:

buildPythonPackage rec {
  pname = "drf-standardized-errors";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ghazi-git";
    repo = "drf-standardized-errors";
    tag = "v${version}";
    hash = "sha256-OM1bTqM3yQSPuerTrq5FKTf5eKpZsF6/QgupMtnnT4Q=";
  };

  build-system = [ flit-core ];

  dependencies = [
    django
    djangorestframework
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    django-filter
    drf-spectacular
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  pythonImportsCheck = [ "drf_standardized_errors" ];

  optional-dependencies.openapi = [
    drf-spectacular
    inflection
  ];

  meta = with lib; {
    description = "Standardize your DRF API error responses";
    homepage = "https://github.com/ghazi-git/drf-standardized-errors";
    changelog = "https://github.com/ghazi-git/drf-standardized-errors/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
