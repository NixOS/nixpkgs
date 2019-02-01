{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bwpgmkh32d7a5dgppin9m0mnh8a33ccl5ksnpw5vjp4lal3xq73";
  };

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  meta = with lib; {
    description = "Use webpack to generate your static bundles";
    homepage = https://github.com/owais/django-webpack-loader;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = with licenses; [ mit ];
  };
}
