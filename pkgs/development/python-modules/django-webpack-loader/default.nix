{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e34085b7fc4d352e482ff9cf7d09ae4524e730675e25432ab1d25a2dd94e583";
  };

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  meta = with lib; {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = with licenses; [ mit ];
  };
}
