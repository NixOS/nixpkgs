{ lib, fetchFromGitHub, buildPythonPackage, django, pytest, pytest-django }:

buildPythonPackage rec {
  pname = "django-logentry-admin";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "yprez";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bndxgvisw8kk52zfdifvly6dl4833wqilxf77pg473172yaf5gq";
  };

  nativeCheckInputs = [ pytest pytest-django ];
  checkPhase = ''
    rm -r logentry_admin __init__.py
    pytest
  '';

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "Show all LogEntry objects in the Django admin site";
    homepage = "https://github.com/yprez/django-logentry-admin";
    license = licenses.isc;
    maintainers = with maintainers; [ mrmebelman ];
  };
}

