{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lxml,
  fastapi,
  httpx,
  pytestCheckHook,
  pytest-cov-stub,
  requests,
}:

buildPythonPackage rec {
  pname = "inscriptis";
  version = "2.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    tag = version;
    hash = "sha256-U6DlFC1faSfw8Cj1lv8JhWIeEyLt+FttUaoFfRfWN7Y=";
  };

  build-system = [ hatchling ];

  dependencies = [
    lxml
    requests
  ];

  nativeCheckInputs = [
    fastapi
    httpx
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonRelaxDeps = [ "lxml" ];

  pythonImportsCheck = [ "inscriptis" ];

  meta = {
    description = "HTML to text converter";
    mainProgram = "inscript.py";
    homepage = "https://github.com/weblyzard/inscriptis";
    changelog = "https://github.com/weblyzard/inscriptis/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
