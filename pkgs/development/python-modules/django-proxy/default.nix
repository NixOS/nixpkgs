{ stdenv, lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "django-proxy";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04mvrs2q620vwz1hvcpnbw5gkiv44arb3ygwd6rlmwjawyx6nfiv";
  };

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "Simple HTTP proxy service as a Django app";
    homepage = https://github.com/mjumbewu/django-proxy;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = with licenses; [ unfree ]; # no license
  };
}
