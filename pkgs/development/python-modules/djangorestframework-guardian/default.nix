{ lib
, buildPythonPackage
, fetchFromGitHub
, django-guardian
, djangorestframework
}:

buildPythonPackage rec {
  pname = "djangorestframework-guardian";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rpkilby";
    repo = "django-rest-framework-guardian";
    rev = version;
    hash = "sha256-jl/VEl1pUHU8J1d5ZQSGJweNJayIGw1iVAmwID85fqw=";
  };

  postPatch = ''
    chmod +x manage.py
    patchShebangs manage.py
  '';

  propagatedBuildInputs = [
    django-guardian
    djangorestframework
  ];

  checkPhase = ''
    ./manage.py test
  '';

  pythonImportsCheck = [ "rest_framework_guardian" ];

  meta = with lib; {
    description = "Django-guardian support for Django REST Framework";
    homepage = "https://github.com/rpkilby/django-rest-framework-guardian";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
