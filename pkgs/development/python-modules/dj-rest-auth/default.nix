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
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "iMerica";
    repo = "dj-rest-auth";
    rev = version;
    sha256 = "sha256-1oxkl7MJ2wIhcHlgxnCtj9Cp8o1puzNWs+vlMyi+3RM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "coveralls>=1.11.1" "" \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    djangorestframework
  ];

  checkInputs = [
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
