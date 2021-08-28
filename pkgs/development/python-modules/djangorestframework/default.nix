{ lib, buildPythonPackage, fetchFromGitHub, django, isPy27 }:

buildPythonPackage rec {
  version = "3.12.2";
  pname = "djangorestframework";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    rev = version;
    sha256 = "y/dw6qIOc6NaNpBWJXDwHX9aFodgKv9rGKWQKS6STlk=";
  };

  # Test settings are missing
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
