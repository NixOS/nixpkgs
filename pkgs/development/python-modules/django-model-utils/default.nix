{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-model-utils";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-model-utils";
    tag = version;
    hash = "sha256-iRtTYXsgD8NYG3k9ZWAr2Nwazo3HUa6RgdbMeDxc7NI=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  # Test requires postgres database
  doCheck = false;

  pythonImportsCheck = [ "model_utils" ];

  meta = {
    homepage = "https://github.com/jazzband/django-model-utils";
    description = "Django model mixins and utilities";
    changelog = "https://github.com/jazzband/django-model-utils/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
