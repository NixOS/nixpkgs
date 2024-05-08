{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dropmqttapi";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ChandlerSystems";
    repo = "dropmqttapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-njReF9Mu5E9o5WcbK60CCBWaIhZ3tpQHHlY/iEyyHGg=";
  };

  build-system = [ setuptools ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "dropmqttapi" ];

  meta = with lib; {
    description = "Python MQTT API for DROP water management products";
    homepage = "https://github.com/ChandlerSystems/dropmqttapi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
