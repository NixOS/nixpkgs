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
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ghazi-git";
    repo = "drf-standardized-errors";
    tag = "v${version}";
    hash = "sha256-Gr4nj2dd0kZTc4IbLhb0i3CnY+VZaNnr3YJctyxIgQU=";
  };

  patches = [
    # fix test_openapi_utils test
    (fetchpatch {
      url = "https://github.com/ghazi-git/drf-standardized-errors/commit/dbc37d4228bdefa858ab299517097d6e52a0b698.patch";
      hash = "sha256-CZTBmhAFKODGLiN2aQNKMaR8VyKs0H55Tzu4Rh6X9R8=";
    })
  ];

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
