{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-tools-simpleeval,
  llm-echo,
  pytestCheckHook,
  simpleeval,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-tools-simpleeval";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-tools-simpleeval";
    tag = version;
    hash = "sha256-IOmYu7zoim7Co/xIm5VLaGkCPI0o+2Nb2Pu3U2fH0BU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    simpleeval
  ];

  nativeCheckInputs = [
    llm-echo
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_tools_simpleeval" ];

  passthru.tests = llm.mkPluginTest llm-tools-simpleeval;

  meta = {
    description = "Make simple_eval available as an LLM tool";
    homepage = "https://github.com/simonw/llm-tools-simpleeval";
    changelog = "https://github.com/simonw/llm-tools-simpleeval/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
