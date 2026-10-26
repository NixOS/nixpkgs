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

buildPythonPackage (finalAttrs: {
  pname = "inscriptis";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    tag = finalAttrs.version;
    hash = "sha256-hNNPY2/SroVQnf04SJ/2yYorBgQJk6d0X616+w41Y1c=";
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
    changelog = "https://github.com/weblyzard/inscriptis/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
