{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "arris-tg2492lg";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vanbalken";
    repo = "arris-tg2492lg";
    tag = version;
    hash = "sha256-MQq9jMUoJgqaY0f9YIbhME2kO+ektPqBnT9REg3qDpg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "arris_tg2492lg" ];

  meta = {
    description = "Library to connect to an Arris TG2492LG";
    homepage = "https://github.com/vanbalken/arris-tg2492lg";
    changelog = "https://github.com/vanbalken/arris-tg2492lg/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
