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
  version = "3.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "epicserve";
    repo = "django-cache-url";
    tag = "v${version}";
    hash = "sha256-SjTcBYaFMD8XwIlqOgoJrc30FLrpX+M2ZcvZzA9ou6g=";
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
