{ buildPythonPackage
, django
, django-stubs-ext
, fetchPypi
, lib
, mypy
, tomli
, types-pytz
, types-pyyaml
, typing-extensions
}:

buildPythonPackage rec {
  pname = "django-stubs";
  version = "1.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vMYYujU9q8VA2YK52sHVoZIWUvj8KhNlPVRaV9XjzA8=";
  };

  propagatedBuildInputs = [
    django
    django-stubs-ext
    mypy
    tomli
    types-pytz
    types-pyyaml
    typing-extensions
  ];

  meta = with lib; {
    description = "PEP-484 stubs for Django";
    homepage = "https://github.com/typeddjango/django-stubs";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
