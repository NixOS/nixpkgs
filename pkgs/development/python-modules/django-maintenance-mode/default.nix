{ lib, fetchFromGitHub, buildPythonPackage, pytest, django }:

buildPythonPackage rec {
  pname = "django-maintenance-mode";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-G08xQpLQxnt7JbtIo06z0NlRAMbca3UWbo4aXQR/Wy0=";
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
