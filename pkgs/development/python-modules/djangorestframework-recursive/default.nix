{ lib
, buildPythonPackage
, django
, djangorestframework
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "djangorestframework-recursive";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "heywbj";
    repo = "django-rest-framework-recursive";
    rev = version;
    hash = "sha256-Q/6yxpz3c402sMZudAeFIht9+5GmTRlzM51AMAx5muY=";
  };

  propagatedBuildInputs = [
    django
    djangorestframework
  ];

  # incompatible with newer django versions
  doCheck = false;

  pythonImportsCheck = [
    "rest_framework_recursive"
  ];

  meta = with lib; {
    description = " Recursive Serialization for Django REST framework ";
    homepage = "https://github.com/heywbj/django-rest-framework-recursive";
    license = licenses.isc;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
