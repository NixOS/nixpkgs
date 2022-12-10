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
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6os10NpJ97LumaeRJfGUPgM0Md0RRybWZDzDXeYZIw4=";
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
