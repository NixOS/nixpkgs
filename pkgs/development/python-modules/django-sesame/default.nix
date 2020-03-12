{ lib, buildPythonPackage, fetchFromGitHub
, django }:

buildPythonPackage rec {
  pname = "django-sesame";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = pname;
    rev = version;
    sha256 = "0k8s44zn2jmasp0w064vrx685fn4pbmdfx8qmhkab1hd5ys6pi44";
  };

  checkInputs = [ django ];

  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description = "URLs with authentication tokens for automatic login";
    homepage = https://github.com/aaugustin/django-sesame;
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
