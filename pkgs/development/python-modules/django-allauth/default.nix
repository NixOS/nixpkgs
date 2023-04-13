{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, python3-openid
, pythonOlder
, requests
, requests-oauthlib
, pyjwt
}:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "0.54.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pennersr";
    repo = pname;
    rev = version;
    hash = "sha256-0yJsHJhYeiCHQg/QzFD/metb97rcUJ+LYlsl7fGYmuM=";
  };

  postPatch = ''
    chmod +x manage.py
    patchShebangs manage.py
  '';

  propagatedBuildInputs = [
    django
    python3-openid
    pyjwt
    requests
    requests-oauthlib
  ]
  ++ pyjwt.optional-dependencies.crypto;

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
    maintainers = with maintainers; [ derdennisop ];
  };
}
