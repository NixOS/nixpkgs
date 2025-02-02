{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "drf-writable-nested";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "drf-writable-nested";
    rev = "refs/tags/v${version}";
    hash = "sha256-+I5HsqkjCrkF9MV90NGQuUhmLcDVsv20QIyDK9WxwdQ=";
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
