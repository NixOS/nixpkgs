{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-crowdstrike";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-crowdstrike";
    tag = "v${version}";
    hash = "sha256-c7+4/55rrVVVdw2Yy8emoiWkyKlCgP4PKdAa1XW+aYM=";
  };

  pythonRelaxDeps = [ "pysigma" ];

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.crowdstrike" ];

  disabledTests = [
    # Windows binary not mocked
    "test_crowdstrike_pipeline_parentimage"
  ];

  meta = {
    description = "Library to support CrowdStrike pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
