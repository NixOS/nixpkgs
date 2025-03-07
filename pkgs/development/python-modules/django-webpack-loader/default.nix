{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sGuDyoGe1Lu4WKtXuNjLZ6JcSlftgi3t1On+5MCXr9U=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  pythonImportsCheck = [ "webpack_loader" ];

  meta = with lib; {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
    changelog = "https://github.com/django-webpack/django-webpack-loader/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
