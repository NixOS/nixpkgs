{ lib, fetchPypi, buildPythonPackage, django }:

buildPythonPackage rec {
  pname = "django-csp";
  version = "3.5";

  src = fetchPypi {
    inherit version;
    pname = "django_csp";
    sha256 = "0ks4zszbjx5lyqlc34pjica8hfcjzw4i5m6pivvnyv8yf0vh4q04";
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
