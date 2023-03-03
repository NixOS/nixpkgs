{ lib
, buildPythonPackage
, fetchFromGitHub
, django-allauth
, djangorestframework
, djangorestframework-simplejwt
, responses
, unittest-xml-reporting
}:

buildPythonPackage rec {
  pname = "dj-rest-auth";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    rev = "refs/tags/${version}";
    hash = "sha256-wkbFUrvKhdp2Hd4QkXAvhMiaqSXFD/fgIw03nLPaO5I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "coveralls>=1.11.1" "" \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    djangorestframework
  ];

  nativeCheckInputs = [
    django-allauth
    djangorestframework-simplejwt
    responses
    unittest-xml-reporting
  ];

  pythonImportsCheck = [ "dj_rest_auth" ];

  meta = with lib; {
    description = "Authentication for Django Rest Framework";
    homepage = "https://github.com/iMerica/dj-rest-auth";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
