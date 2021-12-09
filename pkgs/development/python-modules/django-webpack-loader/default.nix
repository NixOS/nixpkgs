{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "1.4.1";

  src = fetchFromGitHub {
     owner = "owais";
     repo = "django-webpack-loader";
     rev = "1.4.1";
     sha256 = "1gi578x34vva22rf05y24jlfs2nxiy4vrbqsdnlmnvyfcbsi24yh";
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
