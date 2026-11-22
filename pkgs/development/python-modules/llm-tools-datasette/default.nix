{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx2,
  llm,
  llm-tools-datasette,
}:

buildPythonPackage rec {
  pname = "llm-tools-datasette";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-tools-datasette";
    tag = version;
    hash = "sha256-c+bJtki4ASlx0IwJngIMVJPX03RGPZlnamvXZEbFsXc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx2
    llm
  ];

  # there is only one test that asserts the exact tool output
  doCheck = false;

  pythonImportsCheck = [ "llm_tools_datasette" ];

  passthru.tests = llm.mkPluginTest llm-tools-datasette;

  meta = {
    description = "Expose Datasette instances to LLM as a tool";
    homepage = "https://github.com/simonw/llm-tools-datasette";
    changelog = "https://github.com/simonw/llm-tools-datasette/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
