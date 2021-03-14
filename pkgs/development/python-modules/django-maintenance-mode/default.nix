{ lib, fetchFromGitHub, buildPythonPackage, pytest, django }:

buildPythonPackage rec {
  pname = "django-maintenance-mode";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = pname;
    rev = version;
    sha256 = "1k06fhqd8wyrkp795x5j2r328l2phqgg1m1qm7fh4l2qrha43aw6";
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
