{ lib
, buildPythonPackage
, fetchFromGitHub
, django-guardian
, djangorestframework
}:

buildPythonPackage rec {
  pname = "djangorestframework-guardian2";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "johnthagen";
    repo = "django-rest-framework-guardian2";
    rev = "v${version}";
    hash = "sha256-aW20xEmVTAgwayWMJsabmyKNW65NftJyQANtT6JV74U=";
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
    homepage = "https://github.com/johnthagen/django-rest-framework-guardian2/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ e1mo ];
  };
}
