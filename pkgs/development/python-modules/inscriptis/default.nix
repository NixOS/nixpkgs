{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  lxml,
  fastapi,
  httpx,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "inscriptis";
  version = "2.5.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    tag = version;
    hash = "sha256-s19ldUjJm0dnr0aFiKk0G7sXqnxQPgWo9kJYv96WLjM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    lxml
    requests
  ];

  nativeCheckInputs = [
    fastapi
    httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inscriptis" ];

  meta = with lib; {
    description = "HTML to text converter";
    mainProgram = "inscript.py";
    homepage = "https://github.com/weblyzard/inscriptis";
    changelog = "https://github.com/weblyzard/inscriptis/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
