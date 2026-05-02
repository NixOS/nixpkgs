{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyvesync";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdjoe";
    repo = "pyvesync";
    tag = version;
    hash = "sha256-pJv5CMsM82ZUfc9ZuuAut+wHp2pMHOeOqMcH1jg3uRs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    python-dateutil
  ]
  ++ mashumaro.optional-dependencies.orjson;

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    requests
  ];

  pythonImportsCheck = [ "pyvesync" ];

  meta = {
    description = "Python library to manage Etekcity Devices and Levoit Air Purifier";
    homepage = "https://github.com/webdjoe/pyvesync";
    changelog = "https://github.com/webdjoe/pyvesync/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
