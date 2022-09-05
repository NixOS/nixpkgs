{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, django-polymorphic
, djangorestframework
, pytest-django
, pytest-mock
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "django-rest-polymorphic";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "apirobot";
    repo = "django-rest-polymorphic";
    rev = "v${version}";
    sha256 = "sha256-p3ew2NONSyiGzDzxGTy/cx3fcQhhvnzqopJzgqhXadY=";
  };

  propagatedBuildInputs = [
    django
    django-polymorphic
    djangorestframework
    six
  ];

  checkInputs = [
    pytest-django
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rest_polymorphic" ];

  meta = with lib; {
    description = "Polymorphic serializers for Django REST Framework";
    homepage = "https://github.com/apirobot/django-rest-polymorphic";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
