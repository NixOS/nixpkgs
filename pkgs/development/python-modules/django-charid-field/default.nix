{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-charid-field";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yunojuno";
    repo = "django-charid-field";
    rev = "refs/tags/v${version}";
    hash = "sha256-MiEUo12pIfV18F1K5mmYkw7EHn3+sWtzx5jtuQ0BzjY=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    django
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "charidfield" ];

  meta = {
    changelog = "https://github.com/yunojuno/django-charid-field/blob/v${version}/CHANGELOG";
    description = "Provides a char-based, prefixable ID field for your Django models";
    homepage = "https://github.com/yunojuno/django-charid-field";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
