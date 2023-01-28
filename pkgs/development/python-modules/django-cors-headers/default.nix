{ lib
, fetchFromGitHub
, buildPythonPackage
, django
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-cors-headers";
    rev = version;
    sha256 = "sha256-pIyf4poW8/slxj4PVvmXpuYp//v5w00yU0Vz6Jiy2yM=";
  };

  propagatedBuildInputs = [
    django
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = "https://github.com/OttoYiu/django-cors-headers";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
