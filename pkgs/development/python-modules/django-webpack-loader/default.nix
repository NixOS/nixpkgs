{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "087mspmx74qbcknpbksl66rsyin0dc5aglhjmmpk999pl2wvdfk0";
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
