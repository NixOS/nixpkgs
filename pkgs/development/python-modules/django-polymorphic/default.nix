{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  dj-database-url,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-polymorphic";
    repo = "django-polymorphic";
    tag = "v${version}";
    hash = "sha256-QcJUKGhWPUHhVVsEZhhjN411Pz4Wn7OL2fhotPOGVm4=";
  };

  patches = [
    # https://github.com/jazzband/django-polymorphic/issues/616
    ./django-5.1-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    dj-database-url
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "polymorphic" ];

  meta = with lib; {
    changelog = "https://github.com/jazzband/django-polymorphic/releases/tag/${src.tag}";
    homepage = "https://github.com/django-polymorphic/django-polymorphic";
    description = "Improved Django model inheritance with automatic downcasting";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
