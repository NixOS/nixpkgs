{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  python,
  django,
  pytestCheckHook,
  dj-database-url,
  pytest,
}:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "4.0.0a";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-polymorphic";
    rev = "v${version}";
    hash = "sha256-HUfKx/aMdRAa90Do97qzIIc4rEGuwtcQxixG023EWfM=";
  };

  # Fixes https://github.com/jazzband/django-polymorphic/issues/616
  patches = [
    (fetchpatch {
      url = "https://github.com/jazzband/django-polymorphic/commit/a2c48cedc45db52469b93b6fa7a5d50c6722586f.patch";
      hash = "sha256-4PWq6kv0zWBjnQAi//sOY4KWtwI+V2OrtLvyhvsWbzQ=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    dj-database-url
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test --settings="polymorphic_test_settings"
    runHook postCheck
  '';

  pythonImportsCheck = [ "polymorphic" ];

  meta = with lib; {
    homepage = "https://github.com/django-polymorphic/django-polymorphic";
    description = "Improved Django model inheritance with automatic downcasting";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
