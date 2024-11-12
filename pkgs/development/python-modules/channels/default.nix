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
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django";
    repo = "channels";
    rev = "refs/tags/${version}";
    hash = "sha256-JUU1N+Sc7t//0vEdkgQy20iVKgHr4Ys+XnLgqPMcKM8=";
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "channels" ];

  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    homepage = "https://github.com/django/channels";
    changelog = "https://github.com/django/channels/blob/${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
