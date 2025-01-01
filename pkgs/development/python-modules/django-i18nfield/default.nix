{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # tests
  djangorestframework,
  html5lib,
  lxml,
  pytest-django,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage {
  pname = "django-i18nfield";
  version = "1.10.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-i18nfield";
    rev = "10488eb6c673be50e50387c76085a7c8d84e9157";
    hash = "sha256-FF980LTw7RFuG9QgxA96yJsSczCNNMq9WsbacQqIReE=";
  };

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    djangorestframework
    html5lib
    lxml
    pytest-django
    pytestCheckHook
    pyyaml
  ];

  meta = with lib; {
    description = "Store internationalized strings in Django models";
    homepage = "https://github.com/raphaelm/django-i18nfield";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
