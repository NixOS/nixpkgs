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
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdjoe";
    repo = "pyvesync";
    tag = version;
    hash = "sha256-fruuFt7Zb5ZDX8MmEXB4rypuYON3UG50mExnMpMQct4=";
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
