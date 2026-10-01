{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  django,
  zstandard,
  brotli,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-compression-middleware";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DfUPEtd0ZZq8i7yI5MeU8nhajxHzC1uyZ8MUuF2UG3M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    zstandard
    brotli
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  meta = {
    description = "Django middleware to compress responses using several algorithms";
    homepage = "https://github.com/friedelwolff/django-compression-middleware";
    changelog = "https://github.com/friedelwolff/django-compression-middleware/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ e1mo ];
  };
}
