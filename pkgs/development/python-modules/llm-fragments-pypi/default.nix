{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  llm,
  llm-fragments-pypi,
  httpx,
}:

buildPythonPackage rec {
  pname = "llm-fragments-pypi";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samueldg";
    repo = "llm-fragments-pypi";
    tag = version;
    hash = "sha256-1XqAmuZ1WMHD6JbLbLsK9K4Uf3FvvKJD4mn1G2J/3C8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
    llm
  ];

  pythonImportsCheck = [ "llm_fragments_pypi" ];

  passthru.tests = llm.mkPluginTest llm-fragments-pypi;

  meta = {
    description = "LLM fragments plugin for PyPI packages metadata";
    homepage = "https://github.com/samueldg/llm-fragments-pypi";
    changelog = "https://github.com/samueldg/llm-fragments-pypi/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
