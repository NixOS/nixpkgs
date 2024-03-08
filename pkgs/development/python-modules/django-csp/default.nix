{ lib, fetchPypi, buildPythonPackage, django }:

buildPythonPackage rec {
  pname = "django-csp";
  version = "3.8";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "django_csp";
    sha256 = "sha256-7w8an32Nporm4WnALprGYcDs8E23Dg0dhWQFEqaEccA=";
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
