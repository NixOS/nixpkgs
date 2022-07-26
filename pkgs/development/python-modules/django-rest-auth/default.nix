{ lib
 , buildPythonPackage
, fetchFromGitHub
, django
, django-allauth
, djangorestframework
, drf-jwt
, responses
, six
}:

buildPythonPackage rec {
  pname = "django-rest-auth";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "Tivix";
    repo = "django-rest-auth";
    rev = version;
    sha256 = "sha256-rCChUHv8sTEFErDCZnPN5b5XVtMJ7JNVZwBYF3d99mY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "djangorestframework-jwt" "drf-jwt"
  '';

  propagatedBuildInputs = [
    django
    djangorestframework
    six
  ];

  checkInputs = [
    django-allauth
    drf-jwt
    responses
  ];

  # tests are icnompatible with current django version
  doCheck = false;

  pythonImportsCheck = [ "rest_auth" ];

  meta = with lib; {
    description = "Django app that makes registration and authentication easy";
    homepage = "https://github.com/Tivix/django-rest-auth";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
