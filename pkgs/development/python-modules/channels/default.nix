{
  lib,
  asgiref,
  buildPythonPackage,
  daphne,
  django,
  fetchFromGitHub,
  async-timeout,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "channels";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django";
    repo = "channels";
    tag = version;
    hash = "sha256-dRKK6AQNlPdBQumbLmPyOTW96N/PJ9yUY6GYe5x/c+A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    django
  ];

  optional-dependencies = {
    daphne = [ daphne ];
  };

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  # won't run in sandbox
  disabledTestPaths = [
    "tests/sample_project/tests/test_selenium.py"
  ];

  pythonImportsCheck = [ "channels" ];

  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    homepage = "https://github.com/django/channels";
    changelog = "https://github.com/django/channels/blob/${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
