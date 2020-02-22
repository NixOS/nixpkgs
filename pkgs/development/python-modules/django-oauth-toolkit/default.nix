{ stdenv, buildPythonPackage, fetchFromGitHub
, django_2_2, requests, oauthlib
}:

buildPythonPackage rec {
  pname = "django-oauth-toolkit";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = version;
    sha256 = "1zbksxrcxlqnapmlvx4rgvpqc4plgnq0xnf45cjwzwi1626zs8g6";
  };

  propagatedBuildInputs = [ django_2_2 requests oauthlib ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting OAUTH2_PROVIDER, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with stdenv.lib; {
    description = "OAuth2 goodies for the Djangonauts";
    homepage = https://github.com/jazzband/django-oauth-toolkit;
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmai ];
  };
}
