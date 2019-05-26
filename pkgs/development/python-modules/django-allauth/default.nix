{ stdenv, buildPythonPackage, fetchFromGitHub, requests, requests_oauthlib
, django, python3-openid, mock, coverage }:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "0.39.1";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "pennersr";
    repo = pname;
    rev = version;
    sha256 = "1kplkanhj26z3i6p0l1r5lczha4pavcx96vj3kpcp1rvyk1v0f7r";
  };

  propagatedBuildInputs = [ requests requests_oauthlib django python3-openid ];

  checkInputs = [ coverage mock ];

  doCheck = false;
  checkPhase = ''
    cd $NIX_BUILD_TOP/$sourceRoot
    coverage run manage.py test allauth
  '';

  meta = with stdenv.lib; {
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    homepage = https://www.intenct.nl/projects/django-allauth;
    license = licenses.mit;
  };
}
