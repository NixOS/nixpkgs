{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-tools-datasette,
  llm-echo,
  pytestCheckHook,
  pytest-httpx,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-tools-datasette";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-tools-datasette";
    tag = version;
    hash = "sha256-Us9bPk2qpTlgJqQ0Cl9QdeqW+h8j+pmnkriM0WXEyyA=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    llm-echo
    pytestCheckHook
    pytest-httpx
    writableTmpDirAsHomeHook
  ];

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
