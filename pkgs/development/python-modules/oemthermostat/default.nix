{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "oemthermostat";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cadair";
    repo = "openenergymonitor_thermostat";
    tag = "v${version}";
    hash = "sha256-vrMw3/X8MtejO1WyUA1DOlfVCPTCPgcK5p3+OlTWcM4=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oemthermostat" ];

  meta = {
    description = "Python module to interact with OpenEnergyMonitor thermostats";
    homepage = "https://github.com/Cadair/openenergymonitor_thermostat";
    changelog = "https://github.com/Cadair/openenergymonitor_thermostat/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
