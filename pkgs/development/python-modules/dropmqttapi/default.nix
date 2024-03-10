{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "dropmqttapi";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "ChandlerSystems";
    repo = "dropmqttapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-5UnjIv57b4JV/vFyQpe+AS4e/fiE2y7ynZx5g6+oSyQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [
    "dropmqttapi"
  ];

  meta = with lib; {
    description = "Python MQTT API for DROP water management products";
    homepage = "https://github.com/ChandlerSystems/dropmqttapi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
