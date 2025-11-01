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
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webdjoe";
    repo = "pyvesync";
    tag = version;
    hash = "sha256-SZ1ZL79f1FHTnNEU9oew8JcWA20NphIX4fXr3NS7THU=";
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
