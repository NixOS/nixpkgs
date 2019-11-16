{ stdenv, fetchFromGitHub, buildPythonPackage, django, pytest, pytest-django }:

buildPythonPackage rec {
  pname = "django-logentry-admin";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "yprez";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ji04qklzhjb7fx6644vzikjb2196rxyi8hrwf2knsz41ndvq1l9";
  };

  checkInputs = [ pytest pytest-django ];
  checkPhase = ''
    rm -r logentry_admin __init__.py
    pytest
  '';

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Show all LogEntry objects in the Django admin site";
    homepage = "https://github.com/yprez/django-logentry-admin";
    license = licenses.isc;
    maintainers = with maintainers; [ mrmebelman ];
  };
}

