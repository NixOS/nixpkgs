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
  version = "2.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    tag = version;
    hash = "sha256-a6WVgvMDX7A89dafJNuQM6Kh0XaE5ZuvDdDyHterJw8=";
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
