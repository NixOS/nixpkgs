{ lib, fetchPypi, buildPythonPackage, django }:

buildPythonPackage rec {
  pname = "django-csp";
  version = "3.7";

  src = fetchPypi {
    inherit version;
    pname = "django_csp";
    sha256 = "01eda02ad3f10261c74131cdc0b5a6a62b7c7ad4fd017fbefb7a14776e0a9727";
  };

  # too complicated to setup - needs a running django instance
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "Adds Content-Security-Policy headers to Django";
    homepage = "https://github.com/mozilla/django-csp";
    license = licenses.bsd3;
  };
}
