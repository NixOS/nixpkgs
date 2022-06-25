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
  version = "0.51.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pennersr";
    repo = pname;
    rev = version;
    hash = "sha256-o8EoayMMwxoJTrUA3Jo1Dfu1XFgC+Mcpa8yMwXlKAKY=";
  };

  postPatch = ''
    chmod +x manage.py
    patchShebangs manage.py
  '';

  propagatedBuildInputs = [
    django
    python3-openid
    requests
    requests-oauthlib
  ];

  checkPhase = ''
    # test is out of date
    rm allauth/socialaccount/providers/cern/tests.py

    ./manage.py test
  '';

  pythonImportsCheck = [
    "allauth"
  ];

  meta = with lib; {
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    homepage = "https://www.intenct.nl/projects/django-allauth";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
