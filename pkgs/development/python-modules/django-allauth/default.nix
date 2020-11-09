{ stdenv, buildPythonPackage, fetchFromGitHub, requests, requests_oauthlib
, django, python3-openid, mock, coverage }:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "0.43.0";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "pennersr";
    repo = pname;
    rev = version;
    sha256 = "1v206phxd9v32i4yp90rw9fdbwh65wismk1ils1sr08i2nvx37q7";
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
    homepage = "https://www.intenct.nl/projects/django-allauth";
    license = licenses.mit;
  };
}
