{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, djangorestframework
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "drf-writable-nested";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "drf-writable-nested";
    rev = "v${version}";
    sha256 = "sha256-RybtXZ5HipQHaA2RV6TOKIpl6aI9V49mqXDhCH6lg58=";
  };

  propagatedBuildInputs = [
    django
    djangorestframework
  ];

  checkInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Writable nested model serializer for Django REST Framework";
    homepage = "https://github.com/beda-software/drf-writable-nested";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ambroisie ];
  };
}
