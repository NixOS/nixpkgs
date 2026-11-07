{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pymodbus,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-qube-heatpump";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MattieGit";
    repo = "python-qube-heatpump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-83eYbL2mS+821f9hDQe/ladPK+ThFawp+Ij7eI8mtng=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pymodbus
    zeroconf
  ];

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
