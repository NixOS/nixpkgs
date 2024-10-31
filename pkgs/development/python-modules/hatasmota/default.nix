{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "hatasmota";
  version = "0.9.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-m40ZK1+cfWgrwWftFqExUZidCrbDMC1Sfshugqrp5QM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    attrs
    voluptuous
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "hatasmota" ];

  meta = with lib; {
    description = "Python module to help parse and construct Tasmota MQTT messages";
    homepage = "https://github.com/emontnemery/hatasmota";
    changelog = "https://github.com/emontnemery/hatasmota/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
