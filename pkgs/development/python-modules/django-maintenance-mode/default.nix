{ lib, fetchFromGitHub, buildPythonPackage, pytest, django }:

buildPythonPackage rec {
  pname = "django-maintenance-mode";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = pname;
    rev = version;
    sha256 = "0krcq04pf4g50q88l7q1wc53jgkhjmvif3acghfqq8c3s2y7mbz7";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "Shows a 503 error page when maintenance-mode is on";
    homepage = "https://github.com/fabiocaccamo/django-maintenance-mode";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd3;
  };
}
