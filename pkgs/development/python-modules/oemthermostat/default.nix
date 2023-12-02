{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "oemthermostat";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Cadair";
    repo = "openenergymonitor_thermostat";
    rev = "v${version}";
    sha256 = "vrMw3/X8MtejO1WyUA1DOlfVCPTCPgcK5p3+OlTWcM4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "oemthermostat"
  ];

  meta = with lib; {
    description = "Python module to interact with OpenEnergyMonitor thermostats";
    homepage = "https://github.com/Cadair/openenergymonitor_thermostat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
