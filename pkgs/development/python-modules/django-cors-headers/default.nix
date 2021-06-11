{ lib
, fetchFromGitHub
, buildPythonPackage
, django
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-cors-headers";
    rev = version;
    sha256 = "1wc8cs1gpg9v98bq5qwnd4pcv043za50wd63gwkm86lbvjxyxynz";
  };

  propagatedBuildInputs = [
    django
  ];

  checkInputs = [
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
