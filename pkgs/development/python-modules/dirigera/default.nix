{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "dirigera";
  version = "1.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Leggin";
    repo = "dirigera";
    rev = "refs/tags/v${version}";
    hash = "sha256-60DLNp3mM4LpnmM98JVcKlOxj20jvtsBnYq7tL4WEW8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    requests
    websocket-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dirigera" ];

  meta = with lib; {
    description = "Module for controlling the IKEA Dirigera Smart Home Hub";
    homepage = "https://github.com/Leggin/dirigera";
    changelog = "https://github.com/Leggin/dirigera/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "generate-token";
  };
}
