{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyvesync";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdjoe";
    repo = "pyvesync";
    tag = version;
    hash = "sha256-7QtyI5U1NRy0/iujfObdRHkwseetaD2M4f/buj8A9AY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ]
  ++ mashumaro.optional-dependencies.orjson;

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    requests
  ];

  pythonImportsCheck = [ "pyvesync" ];

  meta = with lib; {
    description = "Python library to manage Etekcity Devices and Levoit Air Purifier";
    homepage = "https://github.com/webdjoe/pyvesync";
    changelog = "https://github.com/webdjoe/pyvesync/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
