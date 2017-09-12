{ stdenv, buildPythonPackage, fetchPypi, requests, requests_oauthlib
, django, python3-openid }:

buildPythonPackage rec {
  pname = "django-allauth";
  name = "${pname}-${version}";
  version = "0.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g8akxpk1gywzy40xkpxxdn67zbmir7l4lpzd96ksz3h945shr5f";
  };

  propagatedBuildInputs = [ requests requests_oauthlib django python3-openid ];

  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    homepage = https://www.intenct.nl/projects/django-allauth;
    license = licenses.mit;
  };
}
