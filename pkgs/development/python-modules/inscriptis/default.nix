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
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    tag = version;
    hash = "sha256-m1LZiGu79I9fMQXtL1MuzHxUd6KSwuc87Edkt9sp0DE=";
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
