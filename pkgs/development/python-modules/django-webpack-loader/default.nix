{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-opQY/0FpADW+ENLJSgZV2rCZAJxouJiDmBPWoQmxTXE=";
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
