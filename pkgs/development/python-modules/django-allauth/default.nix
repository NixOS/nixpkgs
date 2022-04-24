{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, python3-openid
, pythonOlder
, requests
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "0.47.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pennersr";
    repo = pname;
    rev = version;
    hash = "sha256-wKrsute6TCl331UrxNEBf/zTtGnyGHsOZQwdiicbg2o=";
  };

  propagatedBuildInputs = [
    requests
    requests-oauthlib
    django
    python3-openid
  ];

  # Tests requires a Django instance
  doCheck = false;

  pythonImportsCheck = [
    "allauth"
  ];

  meta = with lib; {
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    homepage = "https://www.intenct.nl/projects/django-allauth";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
