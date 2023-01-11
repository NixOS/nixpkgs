{ lib
, buildPythonPackage
, fetchFromGitHub

# propagates
, django
, python-dateutil
, scim2-filter-parser
, gssapi
, python-ldap
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
    python-dateutil
    scim2-filter-parser
    gssapi
    python-ldap
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
