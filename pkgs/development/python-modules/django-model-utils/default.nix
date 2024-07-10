{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-model-utils";
  version = "4.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-model-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-GaBTCrEwEkJyVeY5YVptPioYcmivyQtBKjs+TgC9IqA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  # Test requires postgres database
  doCheck = false;

  pythonImportsCheck = [ "model_utils" ];

  meta = with lib; {
    homepage = "https://github.com/jazzband/django-model-utils";
    description = "Django model mixins and utilities";
    changelog = "https://github.com/jazzband/django-model-utils/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
