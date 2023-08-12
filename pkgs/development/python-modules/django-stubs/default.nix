{ lib
, buildPythonPackage
, django
, django-stubs-ext
, fetchPypi
, mypy
, pytestCheckHook
, pythonOlder
, tomli
, types-pytz
, types-pyyaml
, typing-extensions
}:

buildPythonPackage rec {
  pname = "django-stubs";
  version = "4.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2tqzm0bZro83qOh5xZDzmp4EK1ZcA/oMWo91S0QbHyM=";
  };

  propagatedBuildInputs = [
    django
    django-stubs-ext
    mypy
    types-pytz
    types-pyyaml
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "PEP-484 stubs for Django";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
