{ lib,
  fetchFromGitHub,
  django,
  djangorestframework,
  six,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-rest-auth";
  version = "0.9.5";

  src = fetchFromGitHub {
     owner = "Tivix";
     repo = "django-rest-auth";
     rev = "0.9.5";
     sha256 = "0rpngmvifn00cxar7v09sdb5ggp5rmrndhmh282k3cgwgd8a285c";
  };

  propagatedBuildInputs = [ django djangorestframework six ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Django app that makes registration and authentication easy";
    homepage = "https://github.com/Tivix/django-rest-auth";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
