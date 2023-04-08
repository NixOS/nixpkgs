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
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C7+esXLFsG7M/y1wTHw5BuSixhRt+MMu6fOlHikmVYE=";
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
