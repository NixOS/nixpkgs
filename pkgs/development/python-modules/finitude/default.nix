{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  prometheus-client,
  pyserial,
  pythonOlder,
  pyyaml,
  legacy-cgi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "finitude";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dulitz";
    repo = "finitude";
    tag = "v${version}";
    hash = "sha256-yCI5UCRDhw+dJoTKyjmHbAGBm3by2AyxHKlqCywnLcs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    legacy-cgi
    prometheus-client
    pyyaml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "finitude" ];

  meta = {
    description = "Python module to get data from ABCD bus (RS-485) used by Carrier Infinity and Bryant Evolution HVAC systems";
    homepage = "https://github.com/dulitz/finitude";
    changelog = "https://github.com/dulitz/finitude/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
