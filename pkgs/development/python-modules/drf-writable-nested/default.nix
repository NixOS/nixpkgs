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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "drf-writable-nested";
    rev = "refs/tags/v${version}";
    hash = "sha256-/7MZAw0clzzlBdYchUVKldWT7WqtwdSe+016QAP0hqk=";
  };

  propagatedBuildInputs = [
    django
    djangorestframework
  ];

  nativeCheckInputs = [
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
