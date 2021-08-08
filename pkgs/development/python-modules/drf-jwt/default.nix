{ lib
, buildPythonPackage
, fetchFromGitHub
, pyjwt
, djangorestframework
}:

buildPythonPackage rec {
  pname = "drf-jwt";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "Styria-Digital";
    repo = "django-rest-framework-jwt";
    rev = version;
    sha256 = "sha256-++8rFXVsA5WMTt+aC4di3Rpa0BAW285/qM087i9uQ0g=";
  };

  propagatedBuildInputs = [
    pyjwt
    djangorestframework
  ];

  # requires setting up a django instance
  doCheck = false;

  pythonImportsCheck = [
    "rest_framework_jwt"
    "rest_framework_jwt.blacklist"
    # require setting DJANGO_SETTINGS_MODULE
    # "rest_framework_jwt.authentication"
    # "rest_framework_jwt.blacklist.views"
    # "rest_framework_jwt.settings"
    # "rest_framework_jwt.utils"
    # "rest_framework_jwt.views"
  ];

  meta = with lib; {
    description = "JSON Web Token based authentication for Django REST framework";
    homepage = "https://github.com/Styria-Digital/django-rest-framework-jwt";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
