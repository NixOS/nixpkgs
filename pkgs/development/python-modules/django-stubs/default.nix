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
<<<<<<< HEAD
  version = "4.2.3";
=======
  version = "4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-2tqzm0bZro83qOh5xZDzmp4EK1ZcA/oMWo91S0QbHyM=";
=======
    hash = "sha256-k7r/gk8KBW5xA2tCO5QqdPB7kJ5F4/o4GFuRD1l8XAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
