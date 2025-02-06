{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "oemthermostat";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Python module to interact with OpenEnergyMonitor thermostats";
    homepage = "https://github.com/Cadair/openenergymonitor_thermostat";
    changelog = "https://github.com/Cadair/openenergymonitor_thermostat/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
