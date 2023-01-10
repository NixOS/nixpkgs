{ lib
, buildPythonPackage
, fetchFromGitHub

# propagates
, django
, dateutil
, scim2-filter-parser
, gssapi
, ldap
, sssd

# tests
, mock
}:

buildPythonPackage rec {
  pname = "django-scim2";
  version = "0.17.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "15five";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5zdGPpjooiFoj+2OoglXhhKsPFB/KOHvrZWZd+1nZqU=";
  };

  propagatedBuildInputs = [
    django
    dateutil
    scim2-filter-parser
    gssapi
    ldap
    sssd
  ];

  pythonImportsCheck = [
    "django_scim"
  ];

  checkInputs = [
    mock
  ];

  meta = with lib; {
    description = "A SCIM 2.0 Service Provider Implementation (for Django)";
    homepage = "https://github.com/15five/django-scim2";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
