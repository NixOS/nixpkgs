{ lib
, asgiref
, buildPythonPackage
, daphne
, django
, fetchFromGitHub
, pytest-asyncio
, pytest-django
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "channels";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    hash = "sha256-n88MxwYQ4O2kBy/W0Zvi3FtIlhZQQRCssB/lYrFNvps=";
  };

  propagatedBuildInputs = [
    asgiref
    django
  ];

  passthru.optional-dependencies = {
    daphne = [
      daphne
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ] ++ passthru.optional-dependencies.daphne;

  pythonImportsCheck = [
    "channels"
  ];

  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    homepage = "https://github.com/django/channels";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
