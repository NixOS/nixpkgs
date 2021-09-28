{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21f43c7076d83cbfcf03cc2284f94ff2f2ec49d35bf0b9e9f5c1cdea9a16bcab";
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
