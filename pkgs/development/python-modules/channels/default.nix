{ lib
, buildPythonPackage
, fetchFromGitHub
, asgiref
, django
, daphne
, pytest-asyncio
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "channels";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "sha256-bKrPLbD9zG7DwIYBst1cb+zkDsM8B02wh3D80iortpw=";
  };

  propagatedBuildInputs = [
    asgiref
    django
    daphne
  ];

  checkInputs = [
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  pythonImportsCheck = [ "channels" ];

  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    license = licenses.bsd3;
    homepage = "https://github.com/django/channels";
    maintainers = with maintainers; [ fab ];
  };
}
