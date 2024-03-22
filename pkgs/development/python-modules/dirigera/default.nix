{ lib
, buildPythonPackage
, fetchFromGitHub
, pydantic
, pytestCheckHook
, pythonOlder
, requests
, setuptools
, websocket-client
}:

buildPythonPackage rec {
  pname = "dirigera";
  version = "1.0.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Leggin";
    repo = "dirigera";
    rev = "refs/tags/v${version}";
    hash = "sha256-kZlmfoGbvSv13+UqCE73ToLfrzzQ9AOxefRTxUvxMCg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pydantic
    requests
    websocket-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dirigera"
  ];

  meta = with lib; {
    description = "Module for controlling the IKEA Dirigera Smart Home Hub";
    mainProgram = "generate-token";
    homepage = "https://github.com/Leggin/dirigera";
    changelog = "https://github.com/Leggin/dirigera/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
