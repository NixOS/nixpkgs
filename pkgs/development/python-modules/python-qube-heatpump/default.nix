{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pymodbus,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-qube-heatpump";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MattieGit";
    repo = "python-qube-heatpump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p+g/70W09QymkFcjYLhxzYXBQCcPHzUX/hOqAL7/aas=";
  };

  build-system = [ hatchling ];

  dependencies = [ pymodbus ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "python_qube_heatpump" ];

  meta = {
    description = "Async Modbus client for Qube Heat Pumps";
    homepage = "https://github.com/MattieGit/python-qube-heatpump";
    changelog = "https://github.com/MattieGit/python-qube-heatpump/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
