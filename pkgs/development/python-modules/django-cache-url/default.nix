{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-cache-url";
  version = "3.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "epicserve";
    repo = "django-cache-url";
    tag = "v${version}";
    hash = "sha256-nXn/aDTMla4Pi6v93LoElxCpL6AFbbWKTd4TMFaK+Nk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    django
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_cache_url" ];

  meta = {
    description = "Use Cache URLs in your Django application";
    homepage = "https://github.com/epicserve/django-cache-url";
    changelog = "https://github.com/epicserve/django-cache-url/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
